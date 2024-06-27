{ lib, ... }:
{
  options.gipphe.programs._1password-gui.enable = lib.mkEnableOption "_1password-gui";
}
