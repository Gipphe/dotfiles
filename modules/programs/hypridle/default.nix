{
  lib,
  pkgs,
  util,
  config,
  ...
}:
let
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
  dpmsOn = pkgs.writeShellApplication {
    name = "dpms-on";
    text = /* bash */ ''
      case "$XDG_CURRENT_DESKTOP" in
        "Hyprland")
          hyprctl dispatch dpms on
          ;;
        "niri")
          niri msg action power-on-monitors
          ;;
      esac
    '';
  };
  dpmsOff = pkgs.writeShellApplication {
    name = "dpms-off";
    text = /* bash */ ''
      case "$XDG_CURRENT_DESKTOP" in
        "Hyprland")
          hyprctl dispatch dpms off
          ;;
        "niri")
          niri msg action power-off-monitors
          ;;
      esac
    '';
  };
in
util.mkProgram {
  name = "hypridle";
  hm.services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = lib.getExe dpmsOn;
        before_sleep_cmd = hyprlock;
        ignore_dbus_inhibit = false;
        lock_cmd = hyprlock;
      };
      listener = [
        {
          timeout = 900;
          on-timeout = hyprlock;
        }
        {
          timeout = 1200;
          on-timeout = lib.getExe dpmsOff;
          on-resume = lib.getExe dpmsOn;
        }
      ];
    };
  };
}
