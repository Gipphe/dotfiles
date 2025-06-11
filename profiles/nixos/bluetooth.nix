{ lib, config, ... }:
{
  options.gipphe.profiles.nixos.bluetooth.enable = lib.mkEnableOption "nixos.bluetooth profile";
  config = lib.mkIf config.gipphe.profiles.nixos.bluetooth.enable {
    gipphe.system.bluetooth.enable = true;
  };
}
