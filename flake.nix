{
  description = "My personal laptop configuration with Nix";

  inputs = {
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations."Jan-work" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./machines/work/configuration.nix ];
    };
  };
}
