{ lib, ... }:
{
  options.gipphe.programs.mods.enable = lib.mkEnableOption "mods";
}
