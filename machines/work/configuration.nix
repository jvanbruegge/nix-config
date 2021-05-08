{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common.nix
      ../../roles/sway.nix
      ../../temp.nix # TODO: remove
    ];

  networking.hostName = "Jan-work";

  boot.initrd.luks.devices = {
    main = {
      device = "/dev/nvme0n1p2";
    };
  };

  system.stateVersion = "20.09";
}
