{ util, pkgs, ... }:
let
  pkg = pkgs.networkmanager;
in
util.mkProgram {
  name = "networkmanager";
  hm = {
    wayland.windowManager.hyprland.settings.bind = [
      ", XF86WLAN, exec, ${pkg}/bin/nmcli radio wifi toggle"
    ];
  };
}
