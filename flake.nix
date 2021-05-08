{
  description = "My personal laptop configuration with Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations."Jan-work" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      system = "x86_64-linux";
      modules = [
        ./machines/work/configuration.nix
        ./users/jan
        home-manager.nixosModules.home-manager
        { home-manager.extraSpecialArgs = { host = "work"; }; }
      ];
    };
  };
}
