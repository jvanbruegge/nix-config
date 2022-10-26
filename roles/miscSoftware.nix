{ pkgs, host, lib, inputs, ... }:

with pkgs;

{
  home.packages = with pkgs; [
    audible-cli
    btop
    dhall
    dhall-json
    dhall-lsp-server
    dnsutils
    fd
    ffmpeg
    gimp
    gnome.eog
    gnome.evince
    gnome.file-roller
    gnome.nautilus
    gnome.adwaita-icon-theme
    gnumake
    google-chrome
    hexyl
    hunspellDicts.de_DE
    inkscape
    ((inputs.nixpkgs-fork.legacyPackages.x86_64-linux.isabelle.override {
      srcUrl = "http://localhost:8000";
      srcRev = "9f2d6f5eb0a2";
      srcSha256 = "16sfajag5d3r7plbwvak89gdb5hk9gpklb4xzd4iywhnlvddgfc0";
    })) #.withComponents (p: with p; [ isabelle-linter ]))
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
    shellcheck
    signal-desktop
    squeekboard
    speechd
    tealdeer
    texlive.combined.scheme-full
    traceroute
    tree
    usbutils
    vagrant
    xournalpp
    zip
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
      "video/mp4" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
    };
  };
}
