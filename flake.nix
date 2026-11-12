{
  description = "NixOS configuration flake";

  inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  spicetify-nix = {
    url = "github:Gerg-L/spicetify-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  zen-browser = {
    url = "github:0xc000022070/zen-browser-flake";
    inputs = {
      nixpkgs.follows = "nixpkgs";
    };
  };
  lazyvim = {
    url ="github:pfassina/lazyvim-nix";
  };
  plasma-manager = {
    url = "github:nix-community/plasma-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };
  antigravity-nix = {
    url = "github:jacopone/antigravity-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # Must build against the exact KWin it runs in, hence the follows
  kwin-effects-better-blur-dx = {
    url = "github:xarblu/kwin-effects-better-blur-dx";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Claude Code skills (plain repos, pinned in flake.lock)
  ponytail-skill = {
    url = "github:DietrichGebert/ponytail";
    flake = false;
  };
  agent-browser-skill = {
    url = "github:vercel-labs/agent-browser";
    flake = false;
  };
  bigboss-claude-code = {
    url = "github:0xBigBoss/claude-code";
    flake = false;
  };
};

  outputs = { self, nixpkgs, home-manager, spicetify-nix, lazyvim, antigravity-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      sharedModules = [
        ./modules/common.nix
        spicetify-nix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          environment.systemPackages = [
            antigravity-nix.packages.${system}.default # Base App
            #            antigravity-nix.packages.${system}.google-antigravity-ide # IDE
            antigravity-nix.packages.${system}.google-antigravity-cli # CLI
          ];
        }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          # Plasma rewrites files like ~/.gtkrc-2.0 at login; don't fail on stale backups
          home-manager.overwriteBackup = true;
          home-manager.users.saponela = import ./home;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    in
    {
      nixosConfigurations = {
        tetri = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = sharedModules ++ [
            ./hosts/tetri
          ];
        };

        alisferi = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = sharedModules ++ [
            ./hosts/alisferi
          ];
        };

        Alisferi = self.nixosConfigurations.alisferi;
        asliferi = self.nixosConfigurations.alisferi;
        Asliferi = self.nixosConfigurations.alisferi;
      };
    };
}
