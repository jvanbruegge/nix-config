{ config, pkgs, ... }:
let
  monitors = {
    laptop = "BOE NE160QDM-NZ6 Unknown";
    home = "LG Electronics LG ULTRAGEAR 502NTBK2X269";
  };
in
{
  services.kanshi = {
    enable = true;

    settings = [
      {
        profile.name = "home";
        profile.outputs = [
          {
            criteria = monitors.home;
            mode = "3440x1440@99.99Hz";
            position = "0,0";
            scale = 1.0;
            status = "enable";
          }
          {
            criteria = monitors.laptop;
            mode = "2560x1600";
            position = "3440,0";
            scale = 1.0;
            status = "enable";
          }
        ];
      }
      {
        profile.name = "mobile";
        profile.outputs = [ {
          criteria = monitors.laptop;
          scale = 1.0;
          status = "enable";
        } ];
      }
    ];
  };
}
