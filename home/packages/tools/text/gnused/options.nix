{ lib, ... }:
{
  options.gipphe.programs.sed.enable = lib.mkEnableOption "sed";
}
