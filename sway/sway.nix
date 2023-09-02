{ config, pkgs, lib, ... }:
let
  cfg = config.wayland.windowManager.sway.config;
  modifier = cfg.modifier;
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
    ./fnott.nix
  ];

  home.activation = {
    cloneWallpapers = lib.hm.dag.entryAfter ["writeBoundary"]
      ''
      $DRY_RUN_CMD [ ! -e ${config.xdg.configHome}/sway/wallpapers ] && git clone git@github.com:jvanbruegge/wallpapers.git ${config.xdg.configHome}/sway/wallpapers || true
      '';
  };

  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    wl-mirror
    wofi
    pamixer
    swaylock
    brightnessctl
    batsignal
  ];

  # Notify on low battery
  systemd.user.services.batsignal = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit = {
      Description = "Battery status daemon";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.batsignal}/bin/batsignal";
    };
  };

  home.file = {
    wallpaper = {
      source = ./wallpaper.png;
      target = ".config/sway/wallpaper.png";
    };

    lockScript = {
      target = ".config/sway/lock.sh";
      executable = true;
      text = ''
        #!${pkgs.bash}/bin/bash
        set -e
        cache="${config.xdg.cacheHome}/sway"
        list="$cache/lockscreen-wallpapers.txt"
        wallpapers="${config.xdg.configHome}/sway/wallpapers"

        mkdir -p "$cache"

        if [ ! -e "$list" ]; then
          ls "$wallpapers" | shuf > "$list"
        fi

        file=$(head -n1 "$list")
        sed '1d' -i "$list"

        if [[ -z $(grep '[^[:space:]]' "$list") ]]; then
          rm "$list"
        fi

        systemd-cat --identifier swaylock ${pkgs.swaylock}/bin/swaylock --indicator-idle-visible -d -ef -i "$wallpapers/$file"
      '';
    };

    xdgPortal = {
      target = ".config/xdg-desktop-portal-wlr/config";
      text =
        ''
        [screencast]
        max_fps=30
        chooser_type=simple
        chooser_cmd=slurp -f %o -or
        '';
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    extraSessionCommands =
      ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export MOZ_ENABLE_WAYLAND=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      '';

    extraConfig = ''
      for_window [app_id="at.yrlf.wl_mirror"] fullscreen enable
    '';

    config = {
      bars = [];
      modifier = "Mod4";

      window.border = 0;
      floating.border = 0;

      terminal = "${config.programs.alacritty.package}/bin/alacritty";
      menu = "${pkgs.wofi}/bin/wofi --show drun | ${pkgs.findutils}/bin/xargs swaymsg exec --";

      input = {
        "*" = {
          xkb_options = "caps:escape";
          xkb_layout = "us_de";
          tap = "enabled";
        };
      };

      output."*".bg = "$HOME/.config/sway/wallpaper.png fit";

      startup = [
        { command = "systemctl --user restart kanshi"; always = true; }
      ];

      keybindings = builtins.listToAttrs (
        mkNumKeybinding "" (n: "workspace number ${n}")
        ++ mkNumKeybinding "Shift+" (n: "move container to workspace number ${n}")
      ) // {
        "${modifier}+t" = "exec ${cfg.terminal}";
        "${modifier}+d" = "exec ${cfg.menu}";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+f" = "fullscreen";
        "${modifier}+r" = "mode resize";

        # Lock screen
        "${modifier}+Shift+Return" = "exec ${config.xdg.configHome}/sway/lock.sh";

        # Screen mirror
        "${modifier}+Shift+p" = "exec wl-mirror $(slurp -o -f '%o')";

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
        "${modifier}+Shift+Alt+${right}" = "move workspace to output right";

        # Screenshots
        "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "${modifier}+Print" = "exec mkdir -p ~/Screenshots && grim -g \"$(slurp)\" - >~/Screenshots/$(date -Iseconds).png";

        # Volume control
        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer --increase 5";
        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer --decrease 5";
        "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer --toggle-mute";
        "XF86AudioMicMute" = "exec ${pkgs.pamixer}/bin/pamixer --toggle-mute --default-source";

        # Laptop brightness
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set '+5%'";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set '5%-'";
      };
    };
  };
}
