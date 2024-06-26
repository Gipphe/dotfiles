{ lib, config, ... }:
{
  options.gipphe.profiles.virtualisation.vm-guest.enable = lib.mkEnableOption "virtualization.vm-guest";
  config = lib.mkIf config.gipphe.profiles.virtualisation.vm-guest.enable {
    gipphe.virtualisation.virtualbox-guest.enable = true;
  };
}
