let mkConfig = inputs: { host, configuration }: inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  system = "x86_64-linux";
  modules = [
    configuration
    ./users/jan
    inputs.home-manager.nixosModules.home-manager
    { home-manager.extraSpecialArgs = { host = host; }; }
  ];
};
in
mkConfig
