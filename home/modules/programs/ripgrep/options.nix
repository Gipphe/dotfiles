{ lib, ... }:
{
  options.gipphe.programs.ripgrep.enable = lib.mkEnableOption "ripgrep";
}
