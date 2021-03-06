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
      folders = {
        drafts = "[Gmail]/Entw&APw-rfe";
        trash = "[Gmail]/Papierkorb";
        sent = "[Gmail]/Gesendet";
      };
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      neomutt = {
        enable = true;
        mailboxName = "===== gmail.com =====";
        extraMailboxes = [
          { mailbox = "[Gmail]/Gesendet";
            name = "Sent";
          }
          { mailbox = "[Gmail]/Entw&APw-rfe";
            name = "Drafts";
          }
          { mailbox = "[Gmail]/Spam";
            name = "Spam";
          }
        ];
      };
      passwordCommand = "gpg --decrypt ~/.config/neomutt/gmail-password.gpg";
      realName = "Jan van Brügge";
    };
  };
}
