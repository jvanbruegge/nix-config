{ config, pkgs, ... }:

{
    programs.mako = {
      enable = true;
      defaultTimeout = 5000;
    };
}
