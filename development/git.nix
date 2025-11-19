{ config, pkgs, ... }:

{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      dark = true;
      "line-numbers" = true;
      navigate = true;
      "syntax-theme" = "Monokai Extended Bright";
      "hunk-header-style" = "raw";
      "hunk-header-decoration-style" = "none";
    };
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Jan van Brügge";
        email = "supermanitu@gmail.com";
      };

      alias = {
        c = "commit";
        ca = "commit -a";
        caa = "commit -a --amend";

        ch = "checkout";
        chb = "checkout -b";
        chpr = "!sh -c 'git fetch origin pull/$1/head:pr/$1 && git checkout pr/$1' -";

        r = "rebase";
        rc = "rebase --continue";
        ri = "rebase -i";

        a = "add";
        b = "branch";
        d = "diff";
        dc = "diff --cached";
        s = "status";

        st = "stash";
        stp = "stash pop";

        p = "push";
        pu = "pull";

        f = "fetch";

        uu = "!git fetch upstream && git rebase upstream/$(git branch --quiet | grep '*' | cut -c 3-)";

        l = "log --pretty=oneline --abbrev-commit --graph";
      };

      pull.ff = "only";
      merge = {
        ff = false;
        conflictStyle = "zdiff3";
      };
      push = {
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      commit.gpgSign = true;
      tag = {
        gpgSign = true;
        sort = "version:refname";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        renames = true;
        mnemonicPrefix = true;
      };
      init.defaultBranch = "main";
      branch.sort = "-committerdate";
      column.ui = "auto";
    };
  };
}
