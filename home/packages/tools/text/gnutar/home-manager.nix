{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.tar.enable { home.packages = with pkgs; [ gnutar ]; };
}
