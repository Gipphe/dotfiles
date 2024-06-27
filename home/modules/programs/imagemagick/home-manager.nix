{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.imagemagick.enable {
    home.packages = with pkgs; [ imagemagick ];
  };
}
