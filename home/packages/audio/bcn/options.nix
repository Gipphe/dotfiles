{ lib, ... }:
{
  options.gipphe.programs.bcn.enable = lib.mkEnableOption "bcn";
}
