{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.glab.enable { home.packages = with pkgs; [ glab ]; };
}
