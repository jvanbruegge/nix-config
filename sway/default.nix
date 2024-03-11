{ pkgs, ... }:
{
  users.users.greeter = {
    group = "greeter";
    isSystemUser = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd "dbus-run-session sway"
        '';
      };
    };
  };

  home-manager.users.jan = {
    imports = [ ./sway.nix ];
  };
}
