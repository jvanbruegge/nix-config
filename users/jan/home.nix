{ pkgs, ... }:

{
  imports = [
    ../../roles/development.nix
    ../../roles/email/email.nix
    ../../roles/miscSoftware.nix
  ];

  home.stateVersion = "21.05";
}
