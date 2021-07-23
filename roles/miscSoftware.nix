{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gimp
    gnome.file-roller
    gnome.nautilus
    gnome.evince
    signal-desktop
    isabelle
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop";
    };
  };
}
