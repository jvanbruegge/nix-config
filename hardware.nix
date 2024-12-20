{ pkgs, ... }:

{
  # Audio
  environment.systemPackages = [ pkgs.pavucontrol ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Wi-fi
  services.resolved.enable = true;
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
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
}
