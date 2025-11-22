{ util, pkgs, ... }:
let
  pkg = pkgs.brightnessctl;
in
util.mkProgram {
  name = "brightnessctl";
  hm = {
    home.packages = [ pkg ];
    gipphe.core.wm.binds = [
      {
        key = "XF86MonBrightnessUp";
        action.spawn = "${pkg}/bin/brightnessctl set 10%+";
      }
      {
        key = "XF86MonBrightnessDown";
        action.spawn = "${pkg}/bin/brightnessctl set 10%-";
      }
    ];
  };
}
