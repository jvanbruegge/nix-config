{ pkgs, config, lib, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    defaultKeymap = "viins";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./.;
        file = "p10k-config.zsh";
      }
    ];

    envExtra = ''
      function k-env {
        kubectl config set-context $(kubectl config current-context) --namespace="$1"
      }
      function o {
        set +m
        nohup xdg-open $1 2>&1 >/dev/null &
        disown
        set -m
      }
      '';

    sessionVariables = {
      EDITOR = "nvim";
      FZF_DEFAULT_COMMAND = "rg --files --follow --hidden --glob '!.git/'";
    };

    "oh-my-zsh" = {
      enable = true;
    };

    shellAliases = {
      v = "nvim";
      g = "git";
      p = "pnpm";
      px = "pnpx";
      k = "kubectl";
    };
  };
}
