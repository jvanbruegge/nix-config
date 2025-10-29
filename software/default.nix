{ ... }:
{
  programs.adb.enable = true;
  programs.steam.enable = true;

  home-manager.users.jan = { pkgs, lib, ... }: {
    imports = [
      ./firefox.nix
      ./activitywatch.nix
    ];

    home.packages = with pkgs; [
      audible-cli
      btop
      cabal-install
      discord
      dnsutils
      fd
      ffmpeg
      freecad
      gedit
      haskell.compiler.ghc912
      haskell.packages.ghc912.haskell-language-server
      gimp
      eog
      evince
      file-roller
      nautilus
      netbird
      adwaita-icon-theme
      gnumake
      google-chrome
      hexyl
      hunspellDicts.de_DE
      inkscape
      inotify-tools
      (isabelle.withComponents (p: [(p.isabelle-linter.overrideAttrs (_: {
        src = pkgs.fetchFromGitHub {
          owner = "isabelle-prover";
          repo = "isabelle-linter";
          rev = "00bc92e60b3f2f09d1b44616b89dfc300c86f0b9";
          hash = "sha256-SUHeEtZ2eeFrt8SfkC6FgOGugLudq644s2ZaMBywvIQ=";
        };
      }))]))
      jq
      #jellyflix
      kubectl
      libreoffice
      mercurial
      mpv
      nixpkgs-review
      nodePackages.browser-sync
      nodePackages.npm-check-updates
      nodePackages.prettier
      openjdk17
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
