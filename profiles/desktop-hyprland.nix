{ util, ... }:
util.mkProfile "desktop-hyprland" {
  gipphe.environment = {
    desktop.hyprland.enable = true;
    display.enable = true;
    wayland.enable = true;
  };
  gipphe.programs = {
    wl-clipboard.enable = true;
  };
}
