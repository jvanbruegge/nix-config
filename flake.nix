{
  description = "My personal laptop configuration with Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      mkMachine = hostName: machine: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // { inherit hostName; };
        modules = [
          ./configuration.nix
          machine
          home-manager.nixosModule
        ];
      };
    in {
      nixosConfigurations = {
        "Jan-Laptop" = mkMachine "Jan-Laptop" ./machines/laptop.nix;
        "hwlap0036-macs" = mkMachine "hwlap0036-macs" ./machines/university-laptop.nix;
      };
    };
}
