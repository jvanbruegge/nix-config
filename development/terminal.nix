{ pkgs, lib, ... }:
{
  # Fonts & Keyboard layout
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      xdg-utils
    ];
  };

  home-manager.users.jan = { config, ... }:
  let
    configDir = "${config.xdg.configHome}/zsh";
    env = "${configDir}/env";
  in {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      clearDefaultKeybinds = true;
      settings = {
        theme = "Monokai Classic";
        font-family = "Fira Code Nerd Font";
        font-feature = "ss05,ss03,ss02,cv24,ss09";
        cursor-opacity = 0.5;
        keybind = [
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+equal=increase_font_size:1"
          "ctrl+minus=decrease_font_size:1"
        ];
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.eza = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStrings [
          "$os"
          "$directory"
          "$git_branch"
          "$git_status"
          "[ ](fg:prev_bg bg:#272822)"
        ];
        right_format = lib.concatStrings [
          "[](fg:#1d1e19 bg:#272822)"
          "$status"
          "$cmd_duration"
        ];
        os = {
          disabled = false;
          symbols.NixOS = "  ";
          style = "bg:#1d1e19";
        };
        status = {
          disabled = false;
          style = "bg:#1d1e19 fg:bold red";
          success_symbol = "✓";
          success_style = "bg:#1d1e19 fg:bold #a6e22e";
          format = "[ $symbol$maybe_int [](bg:#1d1e19 fg:#ae81ff)]($style)";
          recognize_signal_code = false;
        };
        cmd_duration = {
          format = "[took [$duration](bold $style) 󰔟 ]($style)";
          style = "bg:#ae81ff fg:#1d1e19";
        };
        directory = {
          style = "bg:#e6db74 fg:#1d1e19";
          format = "[[](fg:#1d1e19 bg:#e6db74) $path ]($style)[($read_only )]($style)";
        };
        git_branch = {
          symbol = "";
          style = "bg:#a6e22e fg:#1d1e19";
          format = "[[ ](fg:#e6db74 bg:#a6e22e)$symbol $branch ]($style)";
        };
        git_status = {
          style = "bg:#fd971f fg:#1d1e19";
          format = "([ ](fg:prev_bg bg:#fd971f)[($ahead_behind)($stashed)($staged)($modified)($untracked)]($style))";
          diverged = "⇣$behind_count⇡$ahead_count ";
          ahead = "⇡$count ";
          behind = "⇣$count ";
          stashed = "*$count ";
          staged = "+$count ";
          modified = "!$count ";
          untracked = "?$count ";
        };
      };
    };

    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      defaultKeymap = "viins";
      history = {
        path = "${config.xdg.dataHome}/zsh/zsh_history";
        save = 1000000;
      };
      autosuggestion = {
        enable = true;
        strategy = [ "history" "completion" ];
      };
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;
      plugins = with pkgs; [
        {
          name = "zsh-vi-mode";
          src = zsh-vi-mode;
        }
      ];

      shellAliases = {
        v = "nvim";
        g = "git";
        audible-convert = "$HOME/.config/zsh/audible-convert.sh";
      };

      envExtra = ''
        if [ ! -e "${env}" ] && [ -e "${env}.gpg" ]; then
          gpg --decrypt "${env}.gpg" > "${env}"
        fi

        if [ -e "${env}" ]; then
          source "${env}"
        fi

        export GITHUB_TOKEN

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

        # Accept autosuggestion on shift+enter
        bindkey '^[[27;2;13~' autosuggest-execute

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
        VI_MODE_SET_CURSOR = "true";
        KEYTIMEOUT = "1";
        ZSH_AUTOSUGGEST_HISTORY_IGNORE = "cd *";
      };
    };

    home.file = {
      env = {
        source = ./env.gpg;
        target = "${configDir}/env.gpg";
      };
      audible-convert = {
        source = ../scripts/audible-convert.sh;
        target = "${configDir}/audible-convert.sh";
        executable = true;
      };
    };
  };
}
