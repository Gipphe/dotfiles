{ lib, config, ... }:
{
  options.gipphe.profiles.vm-guest.enable = lib.mkEnableOption "vm-guest";
  config = lib.mkIf config.gipphe.profiles.vm-guest.enable {
    gipphe.virtualisation.virtualbox-guest.enable = true;
  };
}
