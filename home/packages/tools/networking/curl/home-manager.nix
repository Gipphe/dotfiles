{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.curl.enable { home.packages = with pkgs; [ curlFull ]; };
}
