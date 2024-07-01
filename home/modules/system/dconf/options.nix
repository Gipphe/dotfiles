{ lib, ... }:
{
  options.gipphe.system.dconf.enable = lib.mkEnableOption "dconf";
}
