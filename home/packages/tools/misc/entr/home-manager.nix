{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.entr.enable { home.packages = with pkgs; [ entr ]; };
}
