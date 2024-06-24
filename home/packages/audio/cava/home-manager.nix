{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.cava.enable { home.packages = with pkgs; [ cava ]; };
}
