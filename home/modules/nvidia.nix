{ lib, config, ... }:
{
  wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable {
    nvidiaPatches = true;
  };
}
