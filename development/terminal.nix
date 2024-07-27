{ config, pkgs, lib, ... }:
let
  tokyonight = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/folke/tokyonight.nvim/b0e7c7382a7e8f6456f2a95655983993ffda745e/extras/kitty/tokyonight_moon.conf";
    hash = "sha256-aQ38HtUnKq2wH4zM9sskHA2aWIDydW6C1DGC1DlMDeU=";
  };
in {
  programs.kitty = {
    enable = true;

    font = {
      name = "BitstromWera Nerd Font";
      size = 11;
    };

    settings = {
      include = builtins.toString tokyonight;
      scrollback_lines = 10000;
      enable_audio_bell = "no";
      close_on_child_death = "yes";
    };
  };
}
