{ pkgs, config, lib, ... }:

{
  xdg.dataFile.empty = {
    target = "zsh/empty";
    text = "";
  };

  home.packages = with pkgs; [
    xdg-utils
  ];

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    defaultKeymap = "viins";
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      save = 1000000;
    };

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

    envExtra =
      ''
      function k-env {
        kubectl config set-context $(kubectl config current-context) --namespace="$1"
      }
      function o {
        set +m
        nohup xdg-open $1 2>&1 >/dev/null &
        disown
        set -m
      }

      # Only use the local history for the arrow keys
      up-line-or-local-history() {
        zle set-local-history 1
        zle history-substring-search-up
        zle set-local-history 0
      }
      zle -N up-line-or-local-history
      down-line-or-local-history() {
        zle set-local-history 1
        zle history-substring-search-down
        zle set-local-history 0
      }
      zle -N down-line-or-local-history

      # Search local history on Arrow Up/Down and vicmd k/j
      bindkey -M vicmd 'k' up-line-or-local-history
      bindkey -M vicmd 'j' down-line-or-local-history
      bindkey '^[[A' up-line-or-local-history
      bindkey '^[[B' down-line-or-local-history

      # Search global history on PgUp/PgDown and vicmd K/J
      bindkey -M vicmd 'K' history-substring-search-up
      bindkey -M vicmd 'J' history-substring-search-down
      bindkey '^[[5~' history-substring-search-up
      bindkey '^[[6~' history-substring-search-down

      setopt nobeep
      setopt hist_find_no_dups
      '';

    sessionVariables = {
      EDITOR = "nvim";
      FZF_DEFAULT_COMMAND = "rg --files --follow --hidden --glob '!.git/'";
      _Z_DATA = "${config.xdg.dataHome}/zsh/z";
      VI_MODE_SET_CURSOR = "true";
      KEYTIMEOUT = "1";
    };

    "oh-my-zsh" = {
      enable = true;
      plugins = [
        "vi-mode"
        "systemd"
        "colored-man-pages"
        "history-substring-search"
        "kubectl"
        "z"
      ];
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
