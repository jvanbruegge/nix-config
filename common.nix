{ config, pkgs, lib, host, ... }:
{
  imports = [
    ./pipewire.nix
  ];
  
  programs.steam.enable = host != "work";

  nix = {
    nixPath = [ "nixpkgs=${pkgs.path}" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
    binaryCaches = [ "https://hydra.iohk.io" ];
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
    allowUnfree = true;
  };

  services.udev.extraRules =
    ''
    KERNEL=="ttyACM0", MODE="0666"
    '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth = {
    enable = true;
  };

  networking.networkmanager = {
    enable = true;
    packages = with pkgs; [
      networkmanager-openvpn
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  environment.pathsToLink = [ "/share/zsh" ];

  fonts.fonts = with pkgs; [
    dejavu_fonts
    (nerdfonts.override { fonts = [ "BitstreamVeraSansMono" ]; })
    ipafont
  ];

  environment.systemPackages = with pkgs; [
    yubikey-personalization
    docker-compose
  ];

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];
  services.pcscd.enable = true;

  services.xserver.extraLayouts = {
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

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.printing.enable = true;
}
