{ lib, flags, ... }:
{
  config = lib.mkIf flags.system.homeFonts { fonts.fontconfig.enable = true; };
}
