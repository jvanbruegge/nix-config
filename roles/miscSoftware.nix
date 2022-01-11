{ pkgs, host, lib, ... }:

with pkgs;

{
  home.packages = with pkgs; [
    btop
    dhall
    dhall-json
    dhall-lsp-server
    fd
    gimp
    gnome.eog
    gnome.evince
    gnome.file-roller
    gnome.nautilus
    gnome3.adwaita-icon-theme
    gnumake
    google-chrome
    hunspellDicts.de_DE
    inkscape
    isabelle
    jetbrains.idea-community
    jq
    kubectl
    libreoffice
    mpv
    nodePackages.browser-sync
    nodePackages.npm-check-updates
    nodePackages.prettier
    openjdk17
    openssl
    pdftk
    pre-commit
    qrencode
    signal-desktop
    tealdeer
    texlive.combined.scheme-full
    usbutils
    vagrant
    xournalpp
  ] ++ lib.optionals (host == "work") [
    awscli2
    envsubst
    citrix_workspace
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
      "video/mp4" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
    };
  };
}
