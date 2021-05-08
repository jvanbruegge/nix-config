{ config, pkgs, host, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jan van Brügge";
    userEmail =
      if host == "work"
      then
        "jan.van.brugge@futurice.com"
      else
        "supermanitu@gmail.com";

    aliases = {
      c = "commit";
      ca = "commit -a";
      caa = "commit -a --amend";

      ch = "checkout";
      chb = "checkout -b";

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
      pso = "push --set-upstream origin HEAD";
      pu = "pull";

      uu = "!get fetch upstream && git rebase upstream/$(git branch --quiet | grep '*' | cut -c 3-)";

      l = "log --pretty=oneline --abbrev-commit --graph";
    };

    extraConfig = {
      merge.ff = false;
      pull.ff = "only";
      core.pager = "less -F -X";
    };
  };
}
