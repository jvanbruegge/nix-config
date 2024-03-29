# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd = {
    availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "dm-snapshot" ];
    luks.devices.main.device = "/dev/nvme0n1p2";
  };
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b64f0dfa-68d9-4b75-aa05-4b2814894075";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4582-CE68";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/8506806f-5d90-46d0-a63f-1a48297abd53";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d33e0fa4-d941-4156-bcc1-d87dcd0dbdc9"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
