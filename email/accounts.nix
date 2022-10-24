{ pkgs, ... }: {
  home.file.passwords = {
    source = ./passwords;
    target = ".config/aerc/passwords";
  };

  accounts.email.accounts = {
    private = {
      aerc = {
        enable = true;
        extraAccounts = {
          folders-sort = ["INBOX" "Sent" "Drafts" "Spam" "Trash"];
          copy-to = "Sent";
          default = "INBOX";
        };
      };
      passwordCommand = "~/.config/aerc/get-password.sh vanbruegge-de";

      address = "jan@vanbruegge.de";
      userName = "jan@vanbruegge.de";
      imap.host = "imap.1und1.de";
      smtp.host = "smtp.1und1.de";

      primary = true;
      realName = "Jan van Brügge";
    };
  };
}
