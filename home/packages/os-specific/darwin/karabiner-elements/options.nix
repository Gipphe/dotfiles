{ lib, ... }:
{
  options.gipphe.programs.karabiner-elements.enable = lib.mkEnableOption "karabiner-elements";
}
