{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./terminal.nix
    ./zsh/zsh.nix
    ./sway/sway.nix
  ];
}
