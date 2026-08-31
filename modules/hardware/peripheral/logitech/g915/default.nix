{
  util,
  lib,
  config,
  ...
}:
let
  noctalia = "${lib.getExe' config.programs.noctalia.package "noctalia"} msg";
in
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "g915";
  homeManager = {
    gipphe.core.wm.bind = {
      "XF86AudioPlay".action.spawn = "${noctalia} media toggle";
      "XF86AudioPrev".action.spawn = "${noctalia} media previous";
      "XF86AudioNext".action.spawn = "${noctalia} media next";
    };
  };
  nixos = {
    programs.solaar = {
      enable = true;
      userService.enable = true;
    };
    services.hardware.openrgb = {
      enable = true;
    };
  };
}
