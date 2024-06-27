{ lib, ... }:
{
  options.gipphe.programs.cava.enable = lib.mkEnableOption "cava";
}
