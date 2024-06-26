{ lib, config, ... }:
{
  options.gipphe.profiles.desktop.manager.normal.enable = lib.mkEnableOption "desktop.manager.normal";
  config = lib.mkIf config.gipphe.profiles.desktop.manager.normal.enable {
    gipphe.environment.desktop.plasma.enable = true;
  };
}
