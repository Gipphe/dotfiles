{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.tar.enable = lib.mkEnableOption "tar";
  config = lib.mkIf config.gipphe.programs.tar.enable { home.packages = with pkgs; [ gnutar ]; };
}
