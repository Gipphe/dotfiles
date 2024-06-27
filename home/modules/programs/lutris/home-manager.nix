{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.lutris.enable { home.packages = with pkgs; [ lutris ]; };
}
