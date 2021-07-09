{ pkgs, ... }:

{
  imports = [
    ../../roles/development.nix
  ];

  home.stateVersion = "21.05";
}
