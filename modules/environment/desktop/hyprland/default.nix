{ util, ... }:
util.mkToggledModule
  [
    "environment"
    "desktop"
  ]
  {
    name = "hyprland";
    hm.wayland.windowManager.hyprland = {
      enable = true;
    };
    system-nixos = {
      programs = {
        hyprland.enable = true;
        hyprlock.enable = true;
      };
      services = {
        hypridle.enable = true;
        hyprpaper.enable = true;
      };
    };
  }
