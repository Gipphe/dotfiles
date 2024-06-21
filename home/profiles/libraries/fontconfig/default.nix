{ lib, config, ... }:
{
  options.gipphe.profiles.libraries.fonts.enable = lib.mkEnableOption "libraries.fonts";
  config = lib.mkIf config.gipphe.profiles.libraries.fonts.enable {
    gipphe.core.fontconfig.enable = true;
  };
}
