{ pkgs, host, lib, ... }:

with pkgs;

{
  home.packages = with pkgs; [
    dhall
    dhall-json
    dhall-lsp-server
    gimp
    gnome.evince
    gnome.file-roller
    gnome.nautilus
    gnome.eog
    gnome3.adwaita-icon-theme
    gnumake
    google-chrome
    hunspellDicts.de_DE
    inkscape
    isabelle
    jq
    kubectl
    libreoffice
    nodePackages.browser-sync
    nodePackages.npm-check-updates
    nodePackages.prettier
    openssl
    pdftk
    qrencode
    signal-desktop
    texlive.combined.scheme-full
    vagrant
    xournalpp
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
      "image/png" = "org.gnome.eog.desktop";
      "image/bmp" = "org.gnome.eog.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "image/svg+xml" = "org.gnome.eog.desktop";
    };
  };
}
