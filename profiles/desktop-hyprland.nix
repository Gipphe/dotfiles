{ util, ... }:
util.mkProfile "desktop-hyprland" {
  gipphe.environment = {
    desktop.hyprland = {
      enable = true;
      dunst.enable = true;
      mako.enable = false;
      filemanager.enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      hyprpolkitagent.enable = true;
      rofi.enable = true;
      waybar.enable = true;
    };
    display.enable = true;
    wayland.enable = true;
  };
  gipphe.programs = {
    wl-clipboard.enable = true;
  };
}
