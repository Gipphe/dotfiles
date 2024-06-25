{ lib, ... }:
{
  options.gipphe.programs.less.enable = lib.mkEnableOption "less";
}
