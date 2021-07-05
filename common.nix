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
    nerdfonts
  ];
}
