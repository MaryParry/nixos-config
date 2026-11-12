# GNOME settings: what goes where

## Extension settings (Vitals, docks, blur, lockscreen, ...)
Change them in the GUI. They are never reset.

To back them up into this repo (do it whenever you're happy with a change):

    gnome-save

That writes `extensions.ini` here. Commit it like any other file. On a fresh
install, home-manager loads it once, only when no extension settings exist yet.

## Adding or removing an extension
Edit the list in `programs.gnome-shell.extensions` in `home/default.nix`, then rebuild:

    sudo nixos-rebuild switch --flake /etc/nixos#tetri

Find the package name with: `nix search nixpkgs gnome-extensions <name>`
Don't install extensions through Extension Manager: they'd be disabled again at boot.
Extension Manager is fine for browsing and changing extension settings.

## Everything in `dconf.settings` in `home/default.nix`
Fonts, theme, keybindings, favorite apps, input sources, etc.
These are reset at every boot, so change them in the file, not the GUI.
If you'd rather change one in the GUI, delete it from `dconf.settings`.
Then the GUI owns it and it sticks.
