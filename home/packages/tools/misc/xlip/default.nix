{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.xclip.enable = lib.mkEnableOption "xclip";
  config = lib.mkIf config.gipphe.programs.xclip.enable { home.packages = with pkgs; [ xclip ]; };
}
