{ lib, flags, ... }:
{
  config = lib.mkIf flags.homeFonts { fonts.fontconfig.enable = true; };
}
