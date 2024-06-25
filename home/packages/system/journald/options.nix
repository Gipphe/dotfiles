{ lib, ... }:
{
  options.gipphe.system.journald.enable = lib.mkEnableOption "journald";
}
