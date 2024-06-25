{ lib, ... }:
{
  options.gipphe.programs.zoxide.enable = lib.mkEnableOption "zoxide";
}
