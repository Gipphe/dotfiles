{ lib, config, ... }:
{
  options.gipphe.core.fontconfig.enable = lib.mkEnableOption "fontconfig";
  config = lib.mkIf config.gipphe.core.fontconfig.enable { fonts.fontconfig.enable = true; };
}
