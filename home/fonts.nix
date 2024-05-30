{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.flags.homeFonts { fonts.fontconfig.enable = true; };
}
