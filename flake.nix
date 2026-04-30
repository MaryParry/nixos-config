{
  description = "NixOS configuration flake";

  inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  spicetify-nix = {
    url = "github:Gerg-L/spicetify-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  noctalia = {
    url = "github:noctalia-dev/noctalia-shell";
  };

  zen-browser = {
    url = "github:0xc000022070/zen-browser-flake";
    inputs = {
      nixpkgs.follows = "nixpkgs";
    };
  };
};
  outputs = { self, nixpkgs, spicetify-nix, noctalia, ... }@inputs:
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix
        ./noctalia.nix
        spicetify-nix.nixosModules.default
      ];
    };
  };
}