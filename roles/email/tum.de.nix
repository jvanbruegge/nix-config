{ config, pkgs, host, lib, ... }:

{
  home.file.tum-de-password = lib.mkIf (host == "laptop") {
    source = ./tum-de-password.gpg;
    target = ".config/neomutt/tum-de-password.gpg";
  };

  accounts.email.accounts = {
    tum = lib.mkIf (host == "laptop") {
      address = "jan.van-bruegge@tum.de";
      userName = "ga63juq";
      mbsync = {
        enable = true;
        create = "maildir";
        extraConfig.account = {
          PipelineDepth = 10;
        };
      };
      imap.host = "xmail.mwn.de";
      smtp.host = "postout.lrz.de";
      msmtp.enable = true;
      neomutt = {
        enable = true;
        mailboxName = "===== tum.de =====";
        extraMailboxes = [ "Sent" "Drafts" "Junk Email" ];
      };
      passwordCommand = "gpg --decrypt ~/.config/neomutt/tum-de-password.gpg";
      realName = "Jan van Brügge";
    };
  };
}
