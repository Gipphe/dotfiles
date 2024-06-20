{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.sed.enable = lib.mkEnableOption "sed";
  config = lib.mkIf config.gipphe.programs.sed.enable { home.packages = with pkgs; [ gnused ]; };
}
