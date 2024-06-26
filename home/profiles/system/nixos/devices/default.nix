{ lib, config, ... }:
{
  options.gipphe.profiles.system.nixos.devices.enable = lib.mkEnableOption "system.nixos.devices";
  config = lib.mkIf config.gipphe.profiles.system.nixos.devices.enable {
    gipphe.system.udisks2.enable = true;
  };
}
