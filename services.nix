{ pkgs, ... }:
{
  services.fwupd.enable = true;
  services.printing.enable = true;

  virtualisation = {
    docker.enable = true;
  };
  users.users.jan.extraGroups = [ "docker" "vboxusers" ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
}
