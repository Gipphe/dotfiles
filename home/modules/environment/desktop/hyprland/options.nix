{ lib, ... }:
{
  options.gipphe.environment.desktop.hyprland.enable = lib.mkEnableOption "hyprland";
}
