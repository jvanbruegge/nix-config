{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./terminal.nix
    ./zsh/zsh.nix
  ];
}
