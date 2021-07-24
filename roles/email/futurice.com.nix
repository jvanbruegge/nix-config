{ config, pkgs, host, lib, ... }:

{
  home.file = lib.mkIf (host == "work") {
    futurice-gmail-password = {
      source = ./futurice-gmail-password.gpg;
      target = ".config/neomutt/futurice-gmail-password.gpg";
    };
  };

  accounts.email.accounts = lib.mkIf (host == "work") {
    futurice = {
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
}
