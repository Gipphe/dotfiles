{ lib, ... }:
{
  options.gipphe.programs.lutris.enable = lib.mkEnableOption "lutris";
}
