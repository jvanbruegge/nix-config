{ config, pkgs, ... }:
let
  login = "jan";
in
{
  users.users."${login}" = {
    createHome = true;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    group = "users";
    home = "/home/" + login;
    shell = pkgs.zsh;
  };

  nix.trustedUsers = [ login ];

  #home-manager.users."${login}" = import ./home.nix;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
}
