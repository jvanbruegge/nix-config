{ config, pkgs, ... }:
let
  login = "jan";
in
{
  users.users."${login}" = {
    createHome = true;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" "adbusers" "scanner" "lp" ];
    group = "users";
    home = "/home/" + login;
    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [ login ];

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = ["de_DE.UTF-8/UTF-8"];

    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };
}
