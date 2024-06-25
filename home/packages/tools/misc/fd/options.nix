{ lib, ... }:
{
  options.gipphe.programs.fd.enable = lib.mkEnableOption "fd";
}
