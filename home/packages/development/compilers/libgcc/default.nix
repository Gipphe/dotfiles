{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.libgcc.enable = lib.mkEnableOption "libgcc";
  config = lib.mkIf config.gipphe.programs.libgcc.enable { home.packages = with pkgs; [ libgcc ]; };
}
