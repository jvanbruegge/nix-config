{
  description = "My personal laptop configuration with Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations."Jan-work" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/work/configuration.nix
        ./users/jan
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
