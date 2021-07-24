{ config, pkgs, host, lib, ... }:

{
  home.file = lib.mkIf (host == "laptop") {
    gmail-password = {
      source = ./gmail-password.gpg;
      target = ".config/neomutt/gmail-password.gpg";
    };
  };

  accounts.email.accounts = lib.mkIf (host == "laptop") {
    gmail = {
      address = "supermanitu@gmail.com";
      flavor = "gmail.com";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      neomutt = {
        enable = true;
      };
      passwordCommand = "gpg --decrypt ~/.config/neomutt/gmail-password.gpg";
      realName = "Jan van Brügge";
    };
  };
}
