{ lib, ... }:
{
  options.gipphe.system.localization.enable = lib.mkEnableOption "localization";
}
