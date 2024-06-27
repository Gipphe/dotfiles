{ lib, config, ... }:
{
  options.gipphe.profiles.desktop-fancy.enable = lib.mkEnableOption "desktop-fancy profile";
  config = lib.mkIf config.gipphe.profiles.desktop-fancy.enable {
    gipphe.environment.desktop.hyprland.enable = builtins.throw "Hyprland is not really supported in this config";
  };
}
