{ util, pkgs, ... }:
let
  pkg = pkgs.brightnessctl;
in
util.mkProgram {
  name = "brightnessctl";
  homeManager = {
    home.packages = [ pkg ];
    gipphe.core.wm.bind = {
      "XF86MonBrightnessUp".action.spawn = "${pkg}/bin/brightnessctl set 10%+";
      "XF86MonBrightnessDown".action.spawn = "${pkg}/bin/brightnessctl set 10%-";
    };
  };
}
