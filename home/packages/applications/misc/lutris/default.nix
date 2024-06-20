{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.lutris.enable = lib.mkEnableOption "lutris";
  config = lib.mkIf config.gipphe.programs.lutris.enable { home.packages = with pkgs; [ lutris ]; };
}
