{ lib, ... }:
{
  options.gipphe.environment.rice.enable = lib.mkEnableOption "rice";
}
