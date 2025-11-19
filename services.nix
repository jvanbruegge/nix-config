{ pkgs, ... }:
{
  services.fwupd.enable = true;
  services.printing.enable = true;

  services.netbird.enable = true;

  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;
  };
  users.users.jan.extraGroups = [ "docker" "vboxusers" ];
  users.extraGroups.vboxusers.members = [ "jan" ];

  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    config.common = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      # ignore inhibit bc gtk portal always returns as success,
      # despite sway/the wlr portal not having an implementation,
      # stopping firefox from using wayland idle-inhibit
      "org.freedesktop.impl.portal.Inhibit" = [ "none" ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
}
