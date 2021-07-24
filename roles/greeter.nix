{ config, pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      #vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'sh -c \"LIBSEAT_BACKEND=logind systemd-cat --identifier=sway sway\"'";
	user = "greeter";
      };
    };
  };

}
