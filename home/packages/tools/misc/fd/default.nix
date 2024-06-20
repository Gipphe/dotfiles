{ lib, config, ... }:
{
  options.gipphe.programs.fd.enable = lib.mkEnableOption "fd";
  config = lib.mkIf config.gipphe.programs.fd.enable { programs.fd.enable = true; };
}
