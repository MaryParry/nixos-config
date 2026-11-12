{ config, pkgs, lib, inputs, ... }:

# KDE Plasma is configured through System Settings, not here. This file only
# installs what the GUI can choose from. To snapshot the current GUI setup as
# Nix, run `nix run github:nix-community/plasma-manager` (rc2nix).
let
  snowflake = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";

  # Same canvas as the Apple logo it replaces: a ~130px mark in a 450px square,
  # which leaves room below it for the splash's loading spinner
  splashLogo = pkgs.runCommand "nixos-splash-logo.svg" { } ''
    sed -e '0,/viewBox="[^"]*"/s//viewBox="-610 -610 1722 1722"/' \
      -e '0,/height="535"/s//height="450"/' \
      -e '0,/width="535"/s//width="450"/' \
      ${snowflake} > $out
  '';

  # WhiteSur's own layout is a top bar only (no dock), and its clock widget
  # (org.kde.plasma.splitdigitalclock) isn't packaged, so applying the global
  # theme with "Desktop and window layout" wiped the dock and left a hole
  desktopLayout = pkgs.writeText "org.kde.plasma.desktop-layout.js" ''
    panels().forEach(function (panel) { panel.remove(); });

    var bar = new Panel;
    bar.location = "top";
    bar.height = Math.round(gridUnit * 1.6);
    bar.floating = false;
    var launcher = bar.addWidget("org.kde.plasma.kickoff");
    launcher.currentConfigGroup = ["General"];
    launcher.writeConfig("icon", "nix-snowflake-white");
    // The focused app's name in bold, like the macOS menu bar
    var title = bar.addWidget("com.github.antroids.application-title-bar");
    title.currentConfigGroup = ["Appearance"];
    title.writeConfig("widgetElements", ["windowTitle"]);
    title.writeConfig("windowTitleSource", 0); // AppName
    title.writeConfig("windowTitleHideEmpty", true);
    title.writeConfig("windowTitleMarginsLeft", 4);
    bar.addWidget("org.kde.plasma.appmenu");
    bar.addWidget("org.kde.plasma.panelspacer");
    var clock = bar.addWidget("org.kde.plasma.digitalclock");
    clock.currentConfigGroup = ["Appearance"];
    clock.writeConfig("dateDisplayFormat", 1); // BesideTime: "Thu 5 Nov  4:28 PM" on one line
    clock.writeConfig("dateFormat", "custom");
    clock.writeConfig("customDateFormat", "ddd d MMM");
    bar.addWidget("org.kde.plasma.panelspacer");
    var music = bar.addWidget("plasmusic-toolbar");
    music.currentConfigGroup = ["General"];
    music.writeConfig("useAlbumCoverAsPanelIcon", true);
    music.writeConfig("colorsFromAlbumCover", true);
    music.writeConfig("skipBackwardControlInPanel", false);
    music.writeConfig("skipForwardControlInPanel", false);
    ["cpu", "memory"].forEach(function (sensor) {
      var graph = bar.addWidget("org.kde.plasma.systemmonitor." + sensor);
      graph.currentConfigGroup = ["Appearance"];
      graph.writeConfig("chartFace", "org.kde.ksysguard.linechart");
    });
    bar.addWidget("org.kde.plasma.systemtray");
    bar.addWidget("org.kde.milou");

    var dock = new Panel;
    dock.location = "bottom";
    dock.height = Math.round(gridUnit * 3);
    dock.lengthMode = "fit";
    dock.alignment = "center";
    dock.hiding = "dodgewindows";
    // App grid inside the dock: Kickoff in the top bar can't offer "Pin to Task
    // Manager", since Plasma only looks for a task manager in the menu's own panel
    var grid = dock.addWidget("org.kde.plasma.kickerdash");
    grid.currentConfigGroup = ["General"];
    grid.writeConfig("icon", "view-app-grid");
    var tasks = dock.addWidget("org.kde.plasma.icontasks");
    tasks.currentConfigGroup = ["General"];
    tasks.writeConfig("launchers", [
      "preferred://filemanager",
      "preferred://browser",
      "applications:kitty.desktop",
      "applications:systemsettings.desktop",
    ]);
  '';

  # The Mac look without Apple's branding: NixOS logo in place of the Apple
  # logo, and no Finder/Safari/App Store icons
  whitesur-kde = pkgs.whitesur-kde.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      # Without the theme's Apple start.svg, Kickoff uses the icon theme's start-here-kde
      rm $out/share/plasma/desktoptheme/*/icons/start.svg
      for lnf in $out/share/plasma/look-and-feel/*/contents; do
        install -m644 ${splashLogo} $lnf/splash/images/logo.svg
        install -m644 ${desktopLayout} $lnf/layouts/org.kde.plasma.desktop-layout.js
      done
      # Blurs behind every translucent window an app draws itself, which for
      # Telegram's menus means their whole transparent shadow margin. Kvantum's
      # own menu blur (popup_blurring) is separate and stays on
      sed -i 's/^blur_translucent=true/blur_translucent=false/' $out/share/Kvantum/*/*.kvconfig
    '';
  });

  # Stands in for the old Hyprland saturation shader, since KWin can't run
  # custom screen shaders. The profile claims the monitor's primaries are sRGB's
  # pulled 1/saturation of the way toward white, so KWin drives every colour
  # further out to compensate. Gamma 2.2 matches what KWin assumes for sRGB
  vibrantIcc = saturation: pkgs.runCommandCC "vibrant.icc" { buildInputs = [ pkgs.lcms2 ]; } ''
    cat > gen.c <<'EOF'
    #include <lcms2.h>
    #include <stdlib.h>
    int main(int argc, char **argv) {
      double s = atof(argv[1]);
      cmsCIExyY wp = { 0.3127, 0.3290, 1.0 };
      double xy[3][2] = { { 0.64, 0.33 }, { 0.30, 0.60 }, { 0.15, 0.06 } };
      double luma[3] = { 0.212656, 0.715158, 0.072186 };
      cmsCIEXYZ white = { wp.x / wp.y, 1.0, (1 - wp.x - wp.y) / wp.y };
      cmsCIExyY prim[3];
      for (int i = 0; i < 3; i++) {
        double y = luma[i];
        double p[3] = { xy[i][0] / xy[i][1] * y, y, (1 - xy[i][0] - xy[i][1]) / xy[i][1] * y };
        double w[3] = { white.X, white.Y, white.Z };
        for (int c = 0; c < 3; c++) p[c] = p[c] / s + (1 - 1 / s) * luma[i] * w[c];
        cmsCIEXYZ xyz = { p[0], p[1], p[2] };
        cmsXYZ2xyY(&prim[i], &xyz);
      }
      cmsCIExyYTRIPLE primaries = { prim[0], prim[1], prim[2] };
      cmsToneCurve *g = cmsBuildGamma(NULL, 2.2);
      cmsToneCurve *curves[3] = { g, g, g };
      cmsHPROFILE p = cmsCreateRGBProfile(&wp, &primaries, curves);
      cmsMLU *desc = cmsMLUalloc(NULL, 1);
      cmsMLUsetASCII(desc, "en", "US", argv[2]);
      cmsWriteTag(p, cmsSigProfileDescriptionTag, desc);
      return !cmsSaveProfileToFile(p, argv[3]);
    }
    EOF
    $CC gen.c -llcms2 -o gen
    ./gen ${toString saturation} "Vibrant sRGB (saturation x${toString saturation})" $out
  '';

  whitesur-icon-theme = pkgs.whitesur-icon-theme.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      # Most icons are symlinks (jdupes), so replace the files they resolve to
      swap() {
        local replacement
        replacement=$(readlink -f "$2")
        find . -name "$1" -exec readlink -f {} + | sort -u | while read -r f; do
          rm "$f"
          cp "$replacement" "$f"
        done
      }
      cd $out/share/icons
      swap 'start-here*.svg' ${snowflake}
      swap 'nix-snowflake.svg' ${snowflake}
      swap 'file-manager.svg' WhiteSur/places/scalable/default-folder.svg
      swap 'safari.svg' WhiteSur/apps/scalable/app.zen_browser.zen.svg
      swap 'web-browser.svg' WhiteSur/apps/scalable/app.zen_browser.zen.svg
      swap 'system-software-install.svg' WhiteSur/apps/scalable/flatpak-discover.svg
      swap 'softwarecenter.svg' WhiteSur/apps/scalable/flatpak-discover.svg
      for theme in WhiteSur WhiteSur-dark WhiteSur-light; do
        (
          cd $theme
          swap 'system-file-manager-symbolic.svg' "$(find -L . -name folder-symbolic.svg | head -1)"
          swap 'web-browser-symbolic.svg' "$(find -L . -name globe-symbolic.svg | head -1)"
        )
      done

      # Minor icons with an Apple logo, Safari compass, App Store or ⌘ key; the
      # theme inherits Breeze, which takes over once these are gone
      for icon in preferences-desktop-icons rotation-locked-landscape \
          preferences-desktop-navigation ktnef softwarecenter-debian \
          preferences-desktop-keyboard org.kde.plasma.kickerdash; do
        find . -name "$icon.svg" -exec readlink -f {} + | sort -u | xargs -r rm -f
      done
      find . -xtype l -delete
    '';
  });
in
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  home.packages = [
    whitesur-kde
    whitesur-icon-theme
    pkgs.whitesur-cursors
    pkgs.whitesur-gtk-theme
    pkgs.kdePackages.qtstyleplugin-kvantum
    pkgs.application-title-bar
    pkgs.plasmusic-toolbar
    pkgs.inter
  ];

  # KDE writes the GTK settings files itself (System Settings > Application Style);
  # home-manager's read-only copies would block that on this host
  gtk.enable = lib.mkForce false;

  # Previously these were read-only links into the store; give the GUI writable
  # copies on first switch, and never touch them again after that
  home.activation.seedGuiThemeFiles = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    seed() {
      [ -e "$1" ] || { mkdir -p "$(dirname "$1")"; printf '%s\n' "$2" > "$1"; }
    }
    seed ${config.xdg.configHome}/Kvantum/kvantum.kvconfig $'[General]\ntheme=WhiteSurDark'
    seed ${config.home.homeDirectory}/.gtkrc-2.0 $'gtk-theme-name="WhiteSur-Dark"\ngtk-icon-theme-name="breeze-dark"'
    seed ${config.xdg.configHome}/gtk-3.0/settings.ini $'[Settings]\ngtk-theme-name=WhiteSur-Dark\ngtk-icon-theme-name=breeze-dark'
    seed ${config.xdg.configHome}/gtk-4.0/settings.ini $'[Settings]\ngtk-theme-name=WhiteSur-Dark\ngtk-icon-theme-name=breeze-dark'
  '';

  programs.plasma = {
    enable = true;

    # The one setting kept in Nix: Baloo's file indexer saturates disk I/O on the
    # encrypted btrfs /home, stalling kwin/plasmashell for seconds at a time
    configFile.baloofilerc."Basic Settings"."Indexing-Enabled" = false;

    configFile.kwinrc.Plugins.alttabpopEnabled = true;
    # Better Blur DX (installed in hosts/alisferi) replaces the stock blur; the
    # two can't run together. Its settings are under Desktop Effects
    configFile.kwinrc.Plugins.blurEnabled = false;
    configFile.kwinrc.Plugins.better_blur_dxEnabled = true;
  };

  # Pick it in System Settings > Display > Color profile, or:
  #   kscreen-doctor output.HDMI-A-1.iccprofile.$HOME/.local/share/icc/vibrant.icc \
  #     output.HDMI-A-1.colorProfileSource.ICC
  # 1.0 is neutral; the old Hyprland shader ran at 1.2
  xdg.dataFile."icc/vibrant.icc".source = vibrantIcc 1.25;

  # A whole-directory link: KPackage refuses packages whose individual files
  # point outside the package directory
  xdg.dataFile."kwin/effects/alttabpop".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/kwin-effects/alttabpop";
}
