{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.pavucontrol ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
