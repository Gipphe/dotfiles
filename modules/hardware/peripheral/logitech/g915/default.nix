{
  util,
  lib,
  config,
  ...
}:
let
  noctalia-shell = "${lib.getExe' config.programs.noctalia-shell.package "noctalia-shell"} ipc call";
in
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "g915";
  hm = {
    gipphe.core.wm.binds = [
      {
        key = "XF86AudioPlay";
        action.spawn = "${noctalia-shell} media playPause";
      }
      {
        key = "XF86AudioPrev";
        action.spawn = "${noctalia-shell} media previous";
      }
      {
        key = "XF86AudioNext";
        action.spawn = "${noctalia-shell} media next";
      }
    ];
  };
  system-nixos = {
    services.hardware.openrgb = {
      enable = true;
    };
  };
}
