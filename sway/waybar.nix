{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.targets = [ "sway-session.target" ];

    settings = [{
      layer = "top";
      modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "custom/keyboard" "tray" "network" "pulseaudio" "battery" ];
      height = 24;
      modules = {
        "sway/window" = {
          max-length = 50;
        };
        tray = {
          show-passive-items = true;
          icon-size = 20;
        };
        battery = {
          bat = "BAT1";
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        clock.format = "{:%A, %d.%m.  %H:%M}";
        network = {
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ifname}";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-muted = "Muted  {format_source}";
          format-icons = {
            headphones = "";
            default = [ "" "" ];
          };
          format-source = "- ";
          format-source-muted = "- ";
        };
      };
    }];
  };
}
