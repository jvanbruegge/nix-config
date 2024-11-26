{ ... }:
{
  programs.adb.enable = true;
  programs.steam.enable = true;

  home-manager.users.jan = { pkgs, ... }:
  let
    isabelle-language-server = pkgs.fetchFromGitHub {
      owner = "Treeniks";
      repo = "isabelle-language-server";
      rev = "5453ad2f677ba646096a66c22f0bad6ee0de9381";
      hash = "sha256-TgIo5Y1TFa0PPVv2QmBRCKFoYU3tjNNw+7MuN+vc+Zg=";
    };
  in {
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
        prePatch = ''
          rm -r src
          cp -r ${isabelle-language-server}/src src
          cp ${isabelle-language-server}/etc/build.props etc/
          chmod -R +w src etc/build.props

          sed -i 's/Dont_Inline/Hardly_Inline/' src/HOL/Tools/BNF/bnf_lift.ML
        '';
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
      picard
      pre-commit
      qbittorrent
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
      (vagrant.override { withLibvirt = false; })
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
