{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.gnutar.enable { home.packages = with pkgs; [ gnutar ]; };
}
