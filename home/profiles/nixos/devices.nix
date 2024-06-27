{ lib, config, ... }:
{
  options.gipphe.profiles.nixos.devices.enable = lib.mkEnableOption "nixos.devices profile";
  config = lib.mkIf config.gipphe.profiles.nixos.devices.enable { gipphe.udisks2.enable = true; };
}
