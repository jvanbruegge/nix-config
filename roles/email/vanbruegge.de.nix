{ config, pkgs, host, lib, ... }:

{
  home.file.vanbruegge-de-password = lib.mkIf (host == "laptop") {
    source = ./vanbruegge-de-password.gpg;
    target = ".config/neomutt/vanbruegge-de-password.gpg";
  };

  accounts.email.accounts = {
    vanbruegge = lib.mkIf (host == "laptop") {
      address = "jan@vanbruegge.de";
      userName = "jan@vanbruegge.de";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      imap.host = "imap.1und1.de";
      smtp.host = "smtp.1und1.de";
      msmtp.enable = true;
      neomutt = {
        enable = true;
        mailboxName = "===== vanbruegge.de =====";
        extraMailboxes = [ "Sent" "Drafts" "Spam" ];
      };
      passwordCommand = "gpg --decrypt ~/.config/neomutt/vanbruegge-de-password.gpg";
      realName = "Jan van Brügge";
    };
  };
}
