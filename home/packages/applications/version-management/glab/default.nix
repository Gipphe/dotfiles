{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.glab.enable = lib.mkEnableOption "glab";
  config = lib.mkIf config.gipphe.programs.glab.enable { home.packages = with pkgs; [ glab ]; };
}
