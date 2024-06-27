{ lib, ... }:
{
  options.gipphe.programs.nnn.enable = lib.mkEnableOption "nnn";
}
