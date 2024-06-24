{ lib, ... }:
{
  options.gipphe.fish.enable = lib.mkEnableOption "fish";
}
