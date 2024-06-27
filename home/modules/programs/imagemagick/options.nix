{ lib, ... }:
{
  options.gipphe.programs.imagemagick.enable = lib.mkEnableOption "imagemagick";
}
