{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Jan van Brügge";
  };
}
