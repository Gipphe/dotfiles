{ lib, ... }:
{
  options.gipphe.programs.fish.enable = lib.mkEnableOption "fish";
}
