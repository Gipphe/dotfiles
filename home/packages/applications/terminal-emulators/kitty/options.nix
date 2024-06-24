{ lib, ... }:
{
  options.gipphe.programs.kitty.enable = lib.mkEnableOption "kitty";
}
