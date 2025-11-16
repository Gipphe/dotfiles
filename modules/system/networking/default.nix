{
  pkgs,
  config,
  util,
  ...
}:
let
  pkg = pkgs.networkmanager;
in
util.mkToggledModule [ "system" ] {
  name = "networking";
  hm = {
    gipphe.core.wm.binds = [
      {
        key = "XF86WLAN";
        action.spawn = "${pkg}/bin/nmcli radio wifi toggle";
      }
    ];
  };
  system-nixos = {
    networking = {
      inherit (config.gipphe) hostName;
      networkmanager.enable = true;
    };
    users.users.${config.gipphe.username}.extraGroups = [ "networkmanager" ];

    # slows down boot time
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
