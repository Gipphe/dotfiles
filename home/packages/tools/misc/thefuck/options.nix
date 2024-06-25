{ lib, ... }:
{
  options.gipphe.programs.thefuck.enable = lib.mkEnableOption "thefuck";
}
