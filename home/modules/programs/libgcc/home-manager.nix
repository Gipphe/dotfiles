{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.libgcc.enable { home.packages = with pkgs; [ libgcc ]; };
}
