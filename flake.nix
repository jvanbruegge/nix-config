{
  description = "My personal laptop configuration with Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-fork.url = "github:jvanbruegge/nixpkgs/isabelle-2023";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations."Jan-Laptop" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        ./configuration.nix
        ./machines/laptop.nix
        home-manager.nixosModule
        {
          networking.hostName = "Jan-Laptop";
          boot.initrd.luks.devices = {
            main = {
              device = "/dev/nvme0n1p2";
            };
          };
        }
      ];
    };
  };
}
