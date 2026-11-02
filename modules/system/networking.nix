{
  den.aspects.system.networking = {
    homeManager =
      { pkgs, ... }:
      {
        gipphe.core.wm.bind = {
          "XF86WLAN".action.spawn = "${pkgs.networkmanager}/bin/nmcli radio wifi toggle";
        };
      };
    nixos = { host, user }: { config, ... }: {
      networking = {
        inherit (host) hostName;
        networkmanager = {
          enable = true;
          ensureProfiles = {
            environmentFiles = [ config.sensitive.secrets.secrets."pub/networkmanager-secrets.txt" ];
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

        nameservers = [
          "9.9.9.9" # dns.quad9.net
        ];
      };
      users.users.${user.userName}.extraGroups = [ "networkmanager" ];

      # slows down boot time
      systemd.services.NetworkManager-wait-online.enable = false;
    };
  };
}
