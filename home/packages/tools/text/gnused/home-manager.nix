{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.sed.enable { home.packages = with pkgs; [ gnused ]; };
}
