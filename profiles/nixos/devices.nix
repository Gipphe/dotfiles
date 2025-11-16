{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "devices";
  shared.gipphe = {
    programs.udisks2.enable = true;
    system.devices.enable = true;
  };
}
