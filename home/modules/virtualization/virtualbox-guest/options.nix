{ lib, ... }:
{
  options.gipphe.virtualisation.virtualbox-guest.enable = lib.mkEnableOption "virtualbox-guest";
}
