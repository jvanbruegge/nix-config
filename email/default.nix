{
  home-manager.users.jan = { pkgs, ... }: {
    imports = [
      ./accounts.nix
    ];

    home.file = {
      colorize-solarized = {
        target = ".config/aerc/filters/colorize-solarized";
        source = ./colorize-solarized;
      };
      get-password = {
        target = ".config/aerc/get-password.sh";
        executable = true;
        text = ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          file="$XDG_RUNTIME_DIR/aerc/$1"
          if [ -e "$file" ]; then
            cat "$file"
          else
            mkdir -p $(dirname "$file")
            chmod 700 "$(dirname "$file")"
            gpg --decrypt ~/.config/aerc/passwords/$1.gpg | tee "$file"
          fi
        '';
      };
    };

    programs.aerc = {
      enable = true;
      extraConfig = {
        general = {
          unsafe-accounts-conf = true;
          gpg-provider = "gpg";
        };
        ui = {
          dirlist-tree = true;
          dirlist-collapse = 1;
          completion-delay = "10ms";
        };
        filters = {
          "text/plain" = "${pkgs.gawk}/bin/awk -f ~/.config/aerc/filters/colorize-solarized";
          "text/html" = "${pkgs.gawk}/bin/awk -f ${pkgs.aerc}/share/aerc/filters/html";
        };
        triggers.new-email = "exec notify-send \"Private: New email from %n\" \"%s\"";
      };
      extraBinds = {
        messages = {
          j = ":next<Enter>";
          k = ":prev<Enter>";
          J = ":next-folder<Enter>";
          K = ":prev-folder<Enter>";
          L = ":expand-folder<Enter>";
          H = ":collapse-folder<Enter>";
          g = ":select 0<Enter>";
          G = ":select -1<Enter>";
          q = ":quit<Enter>";
          "<Space>" = ":view<Enter>";
          "<C-f>" = ":next 100%<Enter>";
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
          dd = ":delete<Enter>";
          m = ":compose<Enter>";
          r = ":reply -q<Enter>";
          "/" = ":search<space>";
        };
        "messages:folder=Drafts" = {
          "<Space>" = ":recall<Enter>";
        };
        view = {
          q = ":close<Enter>";
          f = ":open-link<space>";
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
        };
      };
    };
  };
}
