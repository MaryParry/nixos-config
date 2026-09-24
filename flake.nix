{
  description = "NixOS configuration flake";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

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
    url = "github:noctalia-dev/noctalia/v5.0.1";
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
    let
      system = "x86_64-linux";
      sharedModules = [
        ./modules/common.nix
        ./modules/noctalia.nix
        spicetify-nix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          environment.systemPackages = [
            antigravity-nix.packages.${system}.default # Base App
            antigravity-nix.packages.${system}.google-antigravity-ide # IDE
            antigravity-nix.packages.${system}.google-antigravity-cli # CLI
          ];
        }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
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
      };
    };
}
