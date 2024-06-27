{ lib, ... }:
{
  options.gipphe.programs.direnv.enable = lib.mkEnableOption "direnv";
}
