{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.entr.enable = lib.mkEnableOption "entr";
  config = lib.mkIf config.gipphe.programs.entr.enable { home.packages = with pkgs; [ entr ]; };
}
