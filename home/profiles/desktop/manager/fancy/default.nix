{ lib, config, ... }:
{
  options.gipphe.profiles.desktop.manager.fancy.enable = lib.mkEnableOption "desktop.manager.fancy";
  config = lib.mkIf config.gipphe.profiles.desktop.manager.fancy.enable {
    gipphe.environment.desktop.hyprland.enable = builtins.throw "Hyprland is not really supported in this config";
  };
}
