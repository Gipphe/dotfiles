{ lib, ... }:
{
  options.gipphe.programs.gnutar.enable = lib.mkEnableOption "gnutar";
}
