{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.vivaldi.enable { home.packages = with pkgs; [ vivaldi ]; };
}
