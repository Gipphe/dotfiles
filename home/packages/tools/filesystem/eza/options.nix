{ lib, ... }:
{
  options.gipphe.programs.eza.enable = lib.mkEnableOption "eza";
}
