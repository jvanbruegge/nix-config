{ config, pkgs, lib, ... }:

let x = "--user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0";
    cmd = "busctl get-property ${x} Visible | awk '{ print \\$2 }'";

in
{
  home.file."toggle-keyboard" = {
    target = ".config/waybar/toggle-keyboard.sh";
    executable = true;
    text =
      ''
      #!/usr/bin/env bash
      if [ "$(${cmd})" = "true" ]; then
        busctl call ${x} SetVisible b false
      else
        busctl call ${x} SetVisible b true
      fi
      '';
  };

  systemd.user.services.squeekboard = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit = {
      Description = "Virtual Keyboard";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.squeekboard}/bin/squeekboard";
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";

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
        "custom/keyboard" = {
          exec = "${pkgs.bash}/bin/bash -c \"${cmd}\"";
          format = "Visible: {}";
          on-click = "$HOME/.config/waybar/toggle-keyboard.sh";
        };
      };
    }];
  };
}
