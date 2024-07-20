{ pkgs, lib, ... }:
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
      discord
      dnsutils
      element-desktop
      fd
      ffmpeg
      gedit
      haskell.compiler.ghc98
      haskell.packages.ghc98.haskell-language-server
      gimp
      eog
      evince
      file-roller
      nautilus
      adwaita-icon-theme
      gnumake
      google-chrome
      hexyl
      hunspellDicts.de_DE
      inkscape
      inotify-tools
      ((isabelle.overrideAttrs (_: {
        patches = [ ./inductive_def.patch ];
      })).withComponents (p: [p.isabelle-linter]))
      jq
      kubectl
      libreoffice
      mercurial
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
