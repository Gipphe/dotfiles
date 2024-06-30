{ util, ... }:
util.mkProfile "desktop-fancy" {
  gipphe.environment.desktop.hyprland.enable = builtins.throw "Hyprland is not really supported in this config";
}
