{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.xclip.enable { home.packages = with pkgs; [ xclip ]; };
}
