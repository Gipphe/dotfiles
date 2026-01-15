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
    sops.secrets.networkmanager-secrets = {
      format = "binary";
      sopsFile = ../../../secrets/pub-networkmanager-secrets.txt;
    };
    networking = {
      inherit (config.gipphe) hostName;
      networkmanager = {
        enable = true;
        ensureProfiles = {
          environmentFiles = [ config.sops.secrets.networkmanager-secrets.path ];
          profiles = {
            "GiphtNet" = {
              connection = {
                id = "GiphtNet";
                type = "wifi";
              };
              ipv4 = {
                dns-search = "";
                method = "auto";
              };
              ipv6 = {
                addr-gen-mode = "stable-privacy";
                dns-search = "";
                method = "auto";
              };
              wifi = {
                mode = "infrastructure";
                ssid = "GiphtNet";
                mac-address-blacklist = "";
              };
              wifi-security = {
                auth-alg = "open";
                key-mgmt = "wpa-psk";
                psk = "$PSK_GIPHTNET";
              };
            };
          };
        };
      };
    };
    users.users.${config.gipphe.username}.extraGroups = [ "networkmanager" ];

    # slows down boot time
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
