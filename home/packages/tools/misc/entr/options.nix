{ lib, ... }:
{
  options.gipphe.programs.entr.enable = lib.mkEnableOption "entr";
}
