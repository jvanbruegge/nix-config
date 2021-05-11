{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    wget
    firefox-wayland
    fzf
    ripgrep
  ];
}
