{ config, pkgs, ... }:

{
  home.file.tridactylrc = {
    target = ".config/tridactyl/tridactylrc";
    text =
      ''
      bind qq tabclose
      set modeindicator false
      set searchurls.hoogle https://hoogle.haskell.org/?hoogle=
      '';
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      forceWayland = true;
      cfg.enableTridactylNative = true;
    };
    profiles.jan = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome =
        ''
        @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"); /* set default namespace to XUL */

        #webrtcIndicator {
          display: none !important;
        }
        '';
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "text/html" = "firefox.desktop";
    };
  };
}
