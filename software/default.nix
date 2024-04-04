{ pkgs, lib, ... }:
{
  programs.adb.enable = true;
  programs.steam.enable = true;

  home-manager.users.jan = { pkgs, ... }: {
    imports = [
      ./firefox.nix
    ];

    home.packages = with pkgs; [
      (audible-cli.overrideAttrs (_: {
        src = pkgs.fetchFromGitHub {
          owner = "mkb79";
          repo = "audible-cli";
          rev = "91b3f63bd35cba638f9a0179c6893a59ecff1d1a";
          hash = "sha256-tgElDv+a4aWMjKoqWgoZWOkhW4naenIEF2JvXFqFcaI=";
        };
      }))
      btop
      cabal-install
      cura
      discord
      dnsutils
      element-desktop
      fd
      ffmpeg
      freecad
      haskell.compiler.ghc98
      haskell.packages.ghc98.haskell-language-server
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
      (isabelle.withComponents (p: [p.isabelle-linter]))
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
      thunderbird
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

    xdg.desktopEntries.thunderbird = {
      name = "Thunderbird";
      exec = "thunderbird %U";
      terminal = false;
      categories = [ "Application" "Network" "Chat" "Email" ];
      mimeType = [ "message/rfc822" "x-scheme-handler/mailto" "text/calendar" "text/x-vcard" ];
    };
  };
}
