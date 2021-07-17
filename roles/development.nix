{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./terminal.nix
    ./nvim.nix
    ./zsh/zsh.nix
    ./sway/sway.nix
    ./firefox.nix
    ./gpg.nix
  ];

  home.packages = with pkgs; [
    stack
    nodejs
    nodePackages.pnpm
  ];
}
