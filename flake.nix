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
  let mkConfig = (import ./mkConfig.nix) inputs;
  in
  {
    nixosConfigurations = {
      "Jan-Laptop" = mkConfig { host = "laptop"; configuration = ./machines/laptop/configuration.nix; };
      "Jan-work" = mkConfig { host = "work"; configuration = ./machines/work/configuration.nix; };
    };
  };
}
