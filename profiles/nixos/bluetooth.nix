{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "bluetooth";
  shared.gipphe.system.bluetooth.enable = true;
}
