{ lib, ... }:
{
  options.gipphe.programs.dconf.enable = lib.mkEnableOption "dconf";
}
