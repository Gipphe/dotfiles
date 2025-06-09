{ util, ... }:
util.mkProfile "desktop-caelestia" {
  gipphe.environment = {
    desktop.hyprland = {
      enable = true;
      caelestia.enable = true;
    };
    display.enable = true;
    wayland.enable = true;
  };
  gipphe.programs = {
    wl-clipboard.enable = true;
  };
}
