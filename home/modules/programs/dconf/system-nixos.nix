{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.dconf.enable { programs.dconf.enable = true; };
}
