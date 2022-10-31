{ config, pkgs, ... }:
let
  monitors = {
    laptop = "Unknown 0x1336 0x00000000";
    work = "Sharp Corporation 0x14D0 0x00000000";
    home = {
      left = "Samsung Electric Company U28E590 HTPK602401";
      right = "Samsung Electric Company U28E590 HTPK602370";
    };
  };
in
{
  services.kanshi = {
    enable = true;

    profiles = {
      home.outputs = [
        {
          criteria = monitors.home.left;
          mode = "3840x2160@60Hz";
          position = "0,0";
          scale = 1.5;
          status = "enable";
        }
        {
          criteria = monitors.home.right;
          mode = "1920x1080@60Hz";
          position = "2560,0";
          scale = 1.0;
          status = "enable";
        }
        {
          criteria = "eDP-1";
          status = "disable";
        }
      ];

      work-mobile.outputs = [
        {
          criteria = monitors.work;
          scale = 2.0;
          status = "enable";
        }
      ];

      mobile.outputs = [
        {
          criteria = monitors.laptop;
          scale = 1.5;
          status = "enable";
        }
      ];
    };
  };
}
