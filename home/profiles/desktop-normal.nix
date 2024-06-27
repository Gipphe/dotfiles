{ lib, config, ... }:
{
  options.gipphe.profiles.desktop-normal.enable = lib.mkEnableOption "desktop-normal profile";
  config = lib.mkIf config.gipphe.profiles.desktop-normal.enable {
    gipphe.environment.desktop.plasma.enable = true;
  };
}
