{ pkgs, nixpkgs-fork, ... }:
{
  programs.adb.enable = true;
  programs.steam.enable = true;

  home-manager.users.jan = { pkgs, ... }: {
    imports = [
      ./firefox.nix
    ];

    home.packages = with pkgs; [
      audible-cli
      btop
      cabal-install
      cura
      dhall
      dhall-json
      dhall-lsp-server
      discord
      dnsutils
      fd
      ffmpeg
      freecad
      haskell.compiler.ghc94
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
      inotify-tools
      (nixpkgs-fork.legacyPackages.x86_64-linux.isabelle.withComponents (p: [p.isabelle-linter]))
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
      unzip
      usbutils
      vagrant
      vlc
      xournalpp
      zip
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
  };
}
