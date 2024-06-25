{ lib, ... }:
{
  options.gipphe.programs.tar.enable = lib.mkEnableOption "tar";
}
