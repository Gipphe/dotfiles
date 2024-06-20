{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.gipphe.programs.cava.enable = lib.mkEnableOption "cava";
  config = lib.mkIf config.gipphe.programs.cava.enable { home.packages = with pkgs; [ cava ]; };
}
