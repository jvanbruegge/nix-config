{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./terminal.nix
    ./nvim.nix
    ./zsh/zsh.nix
    ./sway/sway.nix
  ];

  home.packages = with pkgs; [
    stack
    nodePackages.pnpm
  ];
}
