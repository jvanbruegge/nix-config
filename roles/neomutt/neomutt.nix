{ config, pkgs, host, lib, ... }:

{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  home.file.futurice-gmail-password = lib.mkIf (host == "work") {
    source = ./futurice-gmail-password.gpg;
    target = ".config/neomutt/futurice-gmail-password.gpg";
  };

  accounts.email.maildirBasePath = "Mail";
  accounts.email.accounts = {
    futurice = lib.mkIf (host == "work") {
      address = "jan.van.brugge@futurice.com";
      flavor = "gmail.com";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      neomutt = {
        enable = true;
      };
      passwordCommand = "gpg --decrypt ~/.config/neomutt/futurice-gmail-password.gpg";
      primary = true;
      realName = "Jan van Brügge";
    };
  };

  programs.neomutt = {
    enable = true;
    vimKeys = true;
  };
}
