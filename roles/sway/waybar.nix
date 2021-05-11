{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [{
      layer = "top";
      modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "tray" "network" "pulseaudio" "battery" ];
      height = 22;
      modules = {
        "sway/window" = {
          max-length = 50;
        };
        battery = {
          bat = "BAT0";
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
