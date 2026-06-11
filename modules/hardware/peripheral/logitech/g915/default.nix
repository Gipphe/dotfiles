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
    gipphe.core.wm.binds = [
      {
        key = "XF86AudioPlay";
        action.spawn = "${noctalia} media toggle";
      }
      {
        key = "XF86AudioPrev";
        action.spawn = "${noctalia} media previous";
      }
      {
        key = "XF86AudioNext";
        action.spawn = "${noctalia} media next";
      }
    ];
  };
  nixos = {
    services.hardware.openrgb = {
      enable = true;
    };
  };
}
