{ lib, ... }:
{
  options.gipphe.programs.libgcc.enable = lib.mkEnableOption "libgcc";
}
