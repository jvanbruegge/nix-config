{ pkgs, host, lib, ... }:

with pkgs;

{
  home.packages = with pkgs; [
    gimp
    gnome.file-roller
    gnome.nautilus
    gnome.evince
    gnome3.adwaita-icon-theme
    signal-desktop
    isabelle
    pdftk
    kubectl
    qrencode
    libreoffice
    hunspellDicts.de_DE
    xournalpp
    openssl
    dhall
    dhall-json
    dhall-lsp-server
    vagrant
    google-chrome
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
