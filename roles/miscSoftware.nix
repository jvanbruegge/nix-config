{ pkgs, host, lib, ... }:

with pkgs;

{
  home.packages = with pkgs; [
    gimp
    gnome.file-roller
    gnome.nautilus
    gnome.evince
    signal-desktop
    isabelle
    pdftk
    kubectl
    qrencode
  ] ++ lib.optionals (host == "work") [
    awscli2
    envsubst
  ] ++ lib.optionals (host == "laptop") [
    discord
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop";
    };
  };
}
