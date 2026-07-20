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

  noctalia = {
    url = "github:noctalia-dev/noctalia-shell/9f8dd48c8df5ab1f7f87ddf9842627e1e5682186";
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
  antigravity-nix = {
    url = "github:jacopone/antigravity-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};

  outputs = { self, nixpkgs, home-manager, spicetify-nix, noctalia, lazyvim, antigravity-nix, ... }@inputs:
  {
    nixosConfigurations.tetri = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix
        ./noctalia.nix
        spicetify-nix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          environment.systemPackages = [
            antigravity-nix.packages.x86_64-linux.default # Base App
            antigravity-nix.packages.x86_64-linux.google-antigravity-ide # IDE
            antigravity-nix.packages.x86_64-linux.google-antigravity-cli # CLI
          ];
        }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.saponela = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
