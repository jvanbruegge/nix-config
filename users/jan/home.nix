{ pkgs, ... }:

{
  imports = [
    ../../roles/development.nix
    ../../roles/miscSoftware.nix
  ];

  home.stateVersion = "21.05";
}
