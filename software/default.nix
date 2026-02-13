{ lib, hostName, ... }:
{
  programs.steam.enable = true;

  services.couchdb = lib.mkIf (hostName == "Jan-Work") {
    enable = true;
    adminPass = "admin";
  };

  home-manager.users.jan = { pkgs, lib, ... }: {
    imports = [
      ./firefox.nix
      ./activitywatch.nix
    ];

    home.packages = with pkgs; [
      audible-cli
      bitwarden-desktop
      btop
      cabal-install
      discord
      dnsutils
      fd
      ffmpeg
      freecad
      gedit
      #haskell.compiler.ghc912
      #haskell.packages.ghc912.haskell-language-server
      gimp
      eog
      evince
      file-roller
      mercurial
      nautilus
      netbird
      adwaita-icon-theme
      gnumake
      google-chrome
      hexyl
      hunspellDicts.de_DE
      (inkscape-with-extensions.override {
        inkscapeExtensions = with inkscape-extensions; [ inkstitch ];
      })
      inotify-tools
      (isabelle.withComponents (p: [p.isabelle-linter]))
      jq
      jellyflix
      kubectl
      libreoffice
      mercurial
      mpv
      nixpkgs-review
      nodePackages.npm-check-updates
      nodePackages.prettier
      openjdk21
      openssl
      pdftk
      picard
      pre-commit
      qbittorrent
      qrencode
      shellcheck
      signal-desktop
      squeekboard
      speechd
      tealdeer
      texlive.combined.scheme-small
      thunderbird
      traceroute
      tree
      unzip
      usbutils
      vlc
      xournalpp
      yt-dlp
      zbar
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

    xdg.desktopEntries.thunderbird = {
      name = "Thunderbird";
      exec = "thunderbird %U";
      terminal = false;
      categories = [ "Application" "Network" "Chat" "Email" ];
      mimeType = [ "message/rfc822" "x-scheme-handler/mailto" "text/calendar" "text/x-vcard" ];
    };
  };
}
