{ config, pkgs, host, lib, ... }:

{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  accounts.email.maildirBasePath = "Mail";

  home.packages = with pkgs; [
    urlscan
  ];

  home.file.mailcap = {
    target = ".config/neomutt/mailcap";
    text =
      ''
      application/*; mkdir -p /tmp/neomutt \; cp %s /tmp/neomutt \; xdg-open /tmp/neomutt/$(basename %s) &
      '';
  };

  programs.neomutt = {
    enable = true;
    vimKeys = true;
    sidebar = {
      enable = true;
      format = "%D%?F? [%F]?%* %?N?%N/?%S";
    };
    settings = {
      mailcap_path = "~/.config/neomutt/mailcap";
    };
    binds = [
      { action = "view-attach";
        key = "<space>";
        map = [ "attach" ];
      }
    ];
    macros = [
      {
        action = "<sidebar-prev><sidebar-open>";
        key = "\\Ck";
        map = [ "index" "pager" ];
      }
      {
        action = "<sidebar-next><sidebar-open>";
        key = "\\Cj";
        map = [ "index" "pager" ];
      }
      {
        action = "<pipe-message> urlscan<Enter>";
        key = "f";
        map = [ "index" "pager" ];
      }
      {
        action = "<pipe-entry> urlscan<Enter>";
        key = "\\Cb";
        map = [ "attach" "compose" ];
      }
    ];
    extraConfig =
      ''
      shutdown-hook 'echo `rm -f /tmp/neomutt/*`'
      '';
  };
  
  # Disable automatic sync for the moment
  # services.mbsync.enable = true;
}
