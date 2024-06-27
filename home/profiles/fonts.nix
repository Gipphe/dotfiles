{ lib, config, ... }:
{
  options.gipphe.profiles.fonts.enable = lib.mkEnableOption "fonts";
  config = lib.mkIf config.gipphe.profiles.fonts.enable { gipphe.core.fontconfig.enable = true; };
}
