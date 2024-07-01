{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.system.dconf.enable { programs.dconf.enable = true; };
}
