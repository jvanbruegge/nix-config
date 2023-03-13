{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
  };
}
