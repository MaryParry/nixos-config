{ config, pkgs, inputs, ... }:

{
  # Declarative KDE Plasma 6 Configuration
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "open";
      lookAndFeel = "org.kde.breezeclassic.desktop";
      cursor = {
        theme = "RetroWin98Cursors";
        size = 24;
      };
      iconTheme = "breeze";
      colorScheme = "CommonalitySol";
    };

    shortcuts = {
      "KDE Keyboard Layout Switcher" = {
        "Switch to Next Keyboard Layout" = [ "Meta+Space" "Alt+Shift" ];
      };
      "kactivitymanagerd" = {
        "manage activities" = "none";
      };
      "services/kitty.desktop" = {
        "_launch" = "Meta+Q";
      };
      "services/org.kde.kitty.desktop" = {
        "_launch" = "Meta+Q";
      };
      "plasmashell" = {
        "activate task manager entry 1" = "none";
        "activate task manager entry 2" = "none";
        "activate task manager entry 3" = "none";
        "activate task manager entry 4" = "none";
        "activate task manager entry 5" = "none";
        "activate task manager entry 6" = "none";
        "activate task manager entry 7" = "none";
        "activate task manager entry 8" = "none";
        "activate task manager entry 9" = "none";
      };
      "kwin" = {
        "Window Close" = [ "Meta+Shift+Q" "Alt+F4" ];
        "Window Maximize" = "none";
        "Window Minimize" = "Meta+M";
        "Toggle Fullscreen" = "Meta+F";
        "Window Fullscreen" = "Meta+F";
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
      };
    };

    input.keyboard = {
      layouts = [
        { layout = "us"; }
        { layout = "ge"; }
      ];
      options = [
        "grp:alt_shift_toggle"
        "grp:win_space_toggle"
      ];
    };

    input.touchpads = [
      {
        name = "ELAN030B:00 04F3:3308 Touchpad";
        vendorId = "04F3";
        productId = "3308";
        naturalScroll = true;
      }
    ];

    kwin = {
      edgeBarrier = 0;
      cornerBarrier = false;
    };

    panels = [
      # Top Windows-style Status Panel with Tux Linux Penguin Kickoff icon and Pager workspace visualizer
      {
        location = "top";
        height = 32;
        floating = false;
        lengthMode = "fill";
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "/home/saponela/.local/share/icons/custom_linux_penguin.png";
              };
            };
          }
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.pager"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemtray"
        ];
      }
      # Bottom MacOS/Retro Dock Taskbar
      {
        location = "bottom";
        height = 48;
        floating = false;
        lengthMode = "fill";
        widgets = [
          "org.kde.plasma.icontasks"
        ];
      }
    ];

    configFile = {
      "kdeglobals"."KDE"."WidgetStyle" = "MS Windows 9x";
      "kdeglobals"."KDE"."AnimationDurationFactor" = 0;
      "kdeglobals"."General"."colorScheme" = "CommonalitySol";
      "kdeglobals"."General"."accentColor" = "139,148,171"; # Retro Solaris/Motif Grey Accent
      "kdeglobals"."General"."terminalApplication" = "kitty";
      "kdeglobals"."Icons"."Theme" = "breeze";
      "kdeglobals"."Preferred Applications"."TerminalApplication" = "kitty";
      "kdeglobals"."Preferred Applications"."FileManager" = "org.kde.dolphin.desktop";
      "kwinrc"."org.kde.kdecoration2"."library" = "org.kde.kwin.aurorae";
      "kwinrc"."org.kde.kdecoration2"."theme" = "commonalitysol";
      "kwinrc"."Plugins"."blurEnabled" = true;
      "kwinrc"."Plugins"."translucencyEnabled" = true;
      "kwinrc"."Plugins"."wobblywindowsEnabled" = true; # Retro unixporn Compiz wobbly windows
      "kwinrc"."Plugins"."magiclampEnabled" = true; # Retro genie magic lamp minimize
      "kwinrc"."Compositor"."AnimationSpeed" = 0;
      "kwinrc"."TabBox"."Delay" = 0;
      "kwinrc"."TabBox"."HighlightWindows" = false;
      "kwinrc"."TabBox"."LayoutName" = "compact";
      "kwinrc"."TabBox"."DesktopMode" = 1;
      "kwinrc"."TabBox"."ActivitiesMode" = 1;
      "kwinrc"."TabBox"."ApplicationsMode" = 0;
      "kwinrc"."TabBox"."MinimizedMode" = 0;
      "kwinrc"."TabBox"."MultiScreenMode" = 0;
      "kwinrc"."TabBox"."ShowTabBox" = true;
      "kwinrc"."TabBoxAlternative"."Delay" = 0;
      "kwinrc"."Desktops"."Number" = 4;
      "kwinrc"."Desktops"."Rows" = 1;
      "kcminputrc"."Keyboard"."RepeatDelay" = 250;
      "kcminputrc"."Keyboard"."RepeatRate" = 30;
      "kcminputrc"."Mouse"."cursorTheme" = "RetroWin98Cursors";
      "kcminputrc"."Mouse"."cursorSize" = 24;
      "kcminputrc"."Libinput"."naturalScroll" = true;
      "kcminputrc"."Touchpad"."naturalScroll" = true;
      "plasmarc"."Theme"."name" = "commonalitysol";
      "klaunchrc"."FeedbackStyle"."BusyCursor" = true;
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = true;
      "dolphinrc"."General"."RememberOpenedTabs" = true;
    };
  };
}
