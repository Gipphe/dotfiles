{ lib, ... }:
{
  options.gipphe.programs.curl.enable = lib.mkEnableOption "curl";
}
