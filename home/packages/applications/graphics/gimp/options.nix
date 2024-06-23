{ lib, ... }:
{
  options.gipphe.programs.gimp.enable = lib.mkEnableOption "gimp";
}
