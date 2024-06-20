{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.vivaldi.enable = lib.mkEnableOption "vivaldi";
  config = lib.mkIf config.gipphe.programs.vivaldi.enable { home.packages = with pkgs; [ vivaldi ]; };
}
