{ lib, ... }:
{
  options.gipphe.system.udisks2.enable = lib.mkEnableOption "udisks2";
}
