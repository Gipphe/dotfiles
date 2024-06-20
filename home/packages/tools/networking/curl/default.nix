{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.curl.enable = lib.mkEnableOption "curl";
  config = lib.mkIf config.gipphe.programs.curl.enable { home.packages = with pkgs; [ curlFull ]; };
}
