{ pkgs, lib, ...}:
{
  systemd.user.services.aw-server = {
    Unit = {
      Description = "ActivityWatch Server";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Install.WantedBy = ["graphical-session.target"];

    Service = {
      Type = "notify";
      ExecStart = lib.getExe pkgs.aw-server-rust;
    };
  };

  systemd.user.services.aw-watcher-window-wayland = {
    Unit = {
      Description = "ActivityWatch Wayland Watcher";
      After = ["graphical-session-pre.target" "aw-server.service"];
      PartOf = ["graphical-session.target"];
    };

    Install.WantedBy = ["graphical-session.target"];

    Service.ExecStart = lib.getExe pkgs.aw-watcher-window-wayland;
  };
}
