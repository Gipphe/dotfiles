{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.fd.enable { programs.fd.enable = true; };
}
