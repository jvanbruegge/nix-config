{ pkgs, hostName, ... }:
{
    imports = [
    ./software/default.nix
    ./development/default.nix
    ./sway/default.nix
    ./hardware.nix
    ./gpg.nix
    ./services.nix

    ./users/jan.nix
  ];

  programs.zsh.enable = true;
  home-manager.users.jan = {
    imports = [ ./zsh/zsh.nix ];
    home.stateVersion = "21.05";
  };

  # Options for nix
  nix = {
    nixPath = [ "nixpkgs=${pkgs.path}" ];
    extraOptions = "experimental-features = nix-command flakes";
  };
  nixpkgs.config.allowUnfree = true;

  # System boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
    tmp.cleanOnBoot = false;
  };

  # home-manager config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Fonts & Keyboard layout
  fonts.packages = with pkgs; [
    dejavu_fonts
    nerd-fonts.bitstream-vera-sans-mono
    ipafont
  ];

  networking.hostName = hostName;

  services.xserver.xkb.extraLayouts = {
    us_de = {
      description = "US layout with alt-gr umlauts";
      languages = [ "eng" ];
      symbolsFile = ./symbols/us_de;
    };

    us_de_diff = {
      description = "Helper for us_de";
      languages = [ "eng" ];
      symbolsFile = ./symbols/us_de_diff;
    };
  };

  system.stateVersion = "20.09";

}
