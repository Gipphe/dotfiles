{ util, ... }:
util.mkProfile "desktop-hyprland" {
  gipphe.environment = {
    desktop.hyprland = {
      enable = true;
      dunst.enable = false;
      eww.enable = true;
      filemanager.enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      hyprpolkitagent.enable = true;
      mako.enable = true;
      rofi.enable = false;
      walker.enable = true;
      waybar.enable = true;
      wlogout.enable = true;
    };
    display.enable = true;
    wayland.enable = true;
  };
  gipphe.programs = {
    wl-clipboard.enable = true;
  };
}
