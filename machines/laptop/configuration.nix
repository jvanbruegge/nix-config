{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../common.nix
      ../../roles/greeter.nix
    ];

  networking.hostName = "Jan-Laptop";

  boot.initrd.luks.devices = {
    main = {
      device = "/dev/nvme0n1p2";
    };
  };

  system.stateVersion = "20.09";
}
