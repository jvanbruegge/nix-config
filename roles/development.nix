{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./terminal.nix
    ./zsh/zsh.nix
    ./sway/sway.nix
  ];

  home.packages = with pkgs; [
    stack
  ];
}
