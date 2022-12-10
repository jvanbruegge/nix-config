{ pkgs, nixpkgs-fork, ... }:
{
  programs.adb.enable = true;

  home-manager.users.jan = { pkgs, ... }: {
    imports = [
      ./firefox.nix
    ];

    home.packages = with pkgs; [
      audible-cli
      btop
      dhall
      dhall-json
      dhall-lsp-server
      discord
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
      ((isabelle.overrideAttrs (_:
        let
          src_dev = fetchhg {
            url = "https://isabelle.sketis.net/repos/isabelle";
            rev = "fc35dc967344";
            sha256 = "0a473wjhkg39vy16jrmv621q8l3byr34wh2qxa152f77fbn82lnp";
          };
          zstd = fetchzip {
            url = "https://isabelle.in.tum.de/components/zstd-jni-1.5.2-5.tar.gz";
            sha256 = "052dxzwll5q85i2wwlg4gy7y462b6s10iaxxcjkh2cnsxs8qls66";
          };
        in {
          prePatch = ''
            rm -r src/
            cp -r ${src_dev}/src ./
            cp ${src_dev}/etc/build.props etc/
            chmod -R +w ./src

            name='contrib/zstd-jni-1.5.2-5'
            echo $name >> etc/components
            mkdir -p $name
            cp -r ${zstd}/* $name
            chmod -R +w $name
          '';
        }
      )).withComponents (p: [p.isabelle-linter]))
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
