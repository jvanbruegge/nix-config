{ config, pkgs, ... }:
let
  modifier = config.wayland.windowManager.sway.config.modifier;
  mkNumKeybinding = names: f: builtins.map (
    n: { name = "${modifier}+${names}${toString n}"; value = f (toString n); }
  ) [1 2 3 4 5 6 7 8 9];
  left = "h";
  down = "j";
  up = "k";
  right = "l";
in
{
  imports = [
    ./kanshi.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    wofi
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = null;

    config = {
      bars = [];
      modifier = "Mod4";

      input = {
        "*".xkb_options = "caps:escape";
      };

      keybindings = builtins.listToAttrs (
        mkNumKeybinding "" (n: "workspace number ${n}")
        ++ mkNumKeybinding "Shift+" (n: "move container to workspace number ${n}")
      ) // {
        "${modifier}+t" = "exec ${config.programs.alacritty.package}/bin/alacritty";
        "${modifier}+d" = "wofi --show drun | xargs swaymsg exec --";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+f" = "fullscreen";

        # Move focus
        "${modifier}+${left}" = "focus left";
        "${modifier}+${down}" = "focus down";
        "${modifier}+${up}" = "focus up";
        "${modifier}+${right}" = "focus right";

        # Move focused window
        "${modifier}+Shift+${left}" = "move left";
        "${modifier}+Shift+${down}" = "move down";
        "${modifier}+Shift+${up}" = "move up";
        "${modifier}+Shift+${right}" = "move right";

        # Move workspaces to other monitors
        "${modifier}+Shift+Alt+${left}" = "move workspace to output left";
        "${modifier}+Shift+Alt+${right}" = "move workspace to output righ";

        # Screenshots
        "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "${modifier}+Print" = "exec mkdir -p ~/Screenshots && grim -g \"$(slurp)\" - >~/Screenshots/$(date -Iseconds).png";

        "${modifier}+r" = "mode resize";
      };
    };
  };
}
