{ pkgs, hostName, ... }:
{
    imports = [
    ./software/default.nix
    ./development/default.nix
    ./sway/default.nix
    ./hardware.nix
    ./gpg.nix
    ./services.nix

    ./development/terminal.nix

    ./users/jan.nix
  ];

  programs.zsh.enable = true;
  home-manager.users.jan = {
    home.stateVersion = "21.05";
  };

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  services.printing.drivers = [ pkgs.hplip ];

  # Options for nix
  nix = {
    nixPath = [ "nixpkgs=${pkgs.path}" ];
    extraOptions = "experimental-features = nix-command flakes";
    distributedBuilds = true;
    buildMachines = [ {
      hostName = "minecraft";
      system = "aarch64-linux";
      sshUser = "ubuntu";
      sshKey = "/root/.ssh/minecraft_ed25519";
    } ];
    settings = {
      substituters = [
        "https://nixcache.reflex-frp.org"
        "http://nixcache.heilmannsoftware.net"
      ];
      trusted-public-keys = [
        "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
        "nixcache.heilmannsoftware.net:5kPz/A5gVCs8E96y8PlT10sdAJtAQ5n4n3E0j7UXGQA="
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  # System boot
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = false;
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  }];

  # home-manager config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  networking.hostName = hostName;

  # Fonts & Keyboard layout
  fonts.packages = with pkgs; [
    dejavu_fonts
    ipafont
  ];

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
