{ lib, ... }:
{
  options.gipphe.system.keyboard.enable = lib.mkEnableOption "keyboard";
}
