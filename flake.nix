{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      
      
 #   noctalia = {
#    inputs.nixpkgs.follows = "nixpkgs";
  #    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
   #       ./noctalia.nix
      ];
    };
  };
}
