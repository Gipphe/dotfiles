{ util, pkgs, ... }:
let
  pkg = pkgs.brightnessctl;
in
util.mkProgram {
  name = "brightnessctl";
  hm = {
    home.packages = [ pkg ];
    wayland.windowManager.hyprland.settings.bind = [
      ", XF86MonBrightnessUp, exec, ${pkg}/bin/brightnessctl set 10%+"
      ", XF86MonBrightnessDown, exec, ${pkg}/bin/brightnessctl set 10%-"
    ];
  };
}
