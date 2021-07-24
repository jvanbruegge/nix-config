{ config, pkgs, host, lib, ... }:

{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  accounts.email.maildirBasePath = "Mail";

  programs.neomutt = {
    enable = true;
    vimKeys = true;
  };

  services.mbsync.enable = true;
}
