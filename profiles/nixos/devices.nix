{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "devices";
  shared.gipphe.system.udisks2.enable = true;
}
