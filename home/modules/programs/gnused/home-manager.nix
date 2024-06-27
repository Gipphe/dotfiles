{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.gnused.enable { home.packages = with pkgs; [ gnused ]; };
}
