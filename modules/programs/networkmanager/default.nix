{ util, pkgs, ... }:
let
  pkg = pkgs.networkmanager;
in
util.mkProgram {
  name = "networkmanager";
  hm = {
    gipphe.core.wm.binds = [
      {
        key = "XF86WLAN";
        action.spawn = "${pkg}/bin/nmcli radio wifi toggle";
      }
    ];
  };
}
