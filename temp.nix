{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    firefox-wayland
    fzf
  ];
}
