{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.imagemagick.enable = lib.mkEnableOption "imagemagick";
  config = lib.mkIf config.gipphe.programs.imagemagick.enable {
    home.packages = with pkgs; [ imagemagick ];
  };
}
