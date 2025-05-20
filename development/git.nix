{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jan van Brügge";
    userEmail = "supermanitu@gmail.com";

    aliases = {
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
      d = "diff --word-diff";
      dc = "diff --cached --word-diff";
      s = "status";

      st = "stash";
      stp = "stash pop";

      p = "push";
      pu = "pull";

      f = "fetch";

      uu = "!git fetch upstream && git rebase upstream/$(git branch --quiet | grep '*' | cut -c 3-)";

      l = "log --pretty=oneline --abbrev-commit --graph";
    };

    extraConfig = {
      merge.ff = false;
      pull.ff = "only";
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
      core.pager = "less -F -X";
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
      init.defaultBranch = "master";
      branch.sort = "-committerdate";
      column.ui = "auto";
    };
  };
}
