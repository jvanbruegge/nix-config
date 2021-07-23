{ pkgs, ... }:

{
  imports = [
    ../../roles/development.nix
    ../../roles/neomutt/neomutt.nix
    ../../roles/miscSoftware.nix
  ];

  home.stateVersion = "21.05";
}
