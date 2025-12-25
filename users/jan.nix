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

  i18n.defaultLocale = "en_US.UTF-8";
}
