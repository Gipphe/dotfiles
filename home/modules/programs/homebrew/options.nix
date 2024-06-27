{ lib, ... }:
{
  options.gipphe.programs.homebrew.enable = lib.mkEnableOption "homebrew";
}
