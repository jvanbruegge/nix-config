{ pkgs, ... }:
{
  services.fwupd.enable = true;
  services.printing.enable = true;

  services.netbird = {
    enable = true;
    tunnels.wt0.port = 51821;
  };

  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;
  };
  users.users.jan.extraGroups = [ "docker" "vboxusers" ];
  users.extraGroups.vboxusers.members = [ "jan" ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
}
