{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.core.fontconfig.enable { fonts.fontconfig.enable = true; };
}
