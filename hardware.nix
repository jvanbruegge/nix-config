{ pkgs, ... }:

{
  # Audio
  environment.systemPackages = [ pkgs.pavucontrol ];

  # Scanners
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epkowa ];
    disabledDefaultBackends = [
      "abaton" "agfafocus" "apple" "artec"
      "as6e" "avision" "bh" "canon"
      "cardscan" "coolscan"
      "dell1600n_net" "dmc" "epjitsu" "epson2" "epsonds"
      "escl" "fujitsu" "genesys" "gt68xx" "hp"
      "hs2p" "ibm" "kodak"
      "kvs1025" "kvs20xx" "kvs40xx" "leo"
      "lexmark" "ma1509" "magicolor" "matsushita" "microtek"
      "mustek" "nec"
      "niash" "pie" "pint" "pixma" "plustek"
      "qcam" "ricoh" "rts8891" "s9036"
      "sceptre" "sharp" "sm3600" "sm3840" "snapscan"
      "sp15c" "tamarack" "teco1" "teco2" "teco3"
      "u12" "umax" "v4l" "xerox_mfp"
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Wi-fi
  services.resolved.enable = true;
  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  # Thunderbolt
  services.hardware.bolt.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Video
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
}
