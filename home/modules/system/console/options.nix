{ lib, ... }:
{
  options.gipphe.system.console.enable = lib.mkEnableOption "console";
}
