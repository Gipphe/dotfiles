{ lib, ... }:
{
  options.gipphe.programs.zellij.enable = lib.mkEnableOption "zellij";
}
