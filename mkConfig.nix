let mkConfig = inputs: { host, configuration }: inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; host = host; };
  system = "x86_64-linux";
  modules = [
    configuration
    ./users/jan
    inputs.home-manager.nixosModules.home-manager
    { home-manager.extraSpecialArgs = { host = host; }; }
    ({ pkgs, ...}: {
      nix.registry.nixpkgs.flake = inputs.nixpkgs;
    })
  ];
};
in
mkConfig
