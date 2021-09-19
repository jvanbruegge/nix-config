{ config, pkgs, ... }:
{
  imports = [
    ./pipewire.nix
  ];

  nix = {
    package = pkgs.nixUnstable;
    sandboxPaths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
    allowUnfree = true;
  };

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

  services.printing.enable = true;
}
