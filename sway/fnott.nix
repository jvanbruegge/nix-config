{ config, pkgs, ... }:

{
  services.fnott = {
    enable = true;
    settings.main = {
      max-width = 800;
      max-timeout = 10;
      default-timeout = 10;
      title-font = "BitstromWera Nerd Font:size=16";
      summary-font = "BitstromWera Nerd Font:size=20";
      body-font = "BitstromWera Nerd Font:size=16";
    };
  };
}
