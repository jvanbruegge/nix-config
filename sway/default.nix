{ pkgs, ... }:
{
  programs.sway.enable = true;

  users.users.greeter = {
    group = "greeter";
    isSystemUser = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'sh -c \"LIBSEAT_BACKEND=logind systemd-cat --identifier=sway sway\"'";
      };
    };
  };

  home-manager.users.jan = {
    imports = [ ./sway.nix ];
  };
}
