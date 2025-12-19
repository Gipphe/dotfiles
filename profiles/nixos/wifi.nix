{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "wifi";
  shared.gipphe.system.wifi.enable = true;
}
