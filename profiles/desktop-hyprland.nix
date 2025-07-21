{ util, ... }:
util.mkProfile "desktop-hyprland" {
  gipphe.environment = {
    desktop.hyprland = {
      enable = true;
      ashell.enable = true;
      dunst.enable = false;
      eww.enable = false;
      filemanager.enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      hyprpolkitagent.enable = true;
      mako.enable = false;
      rofi.enable = false;
      swaync.enable = true;
      walker.enable = true;
      waybar.enable = false;
      wlogout.enable = true;
    };
    display.enable = true;
    wayland.enable = true;
  };
  gipphe.programs = {
    networkmanagerapplet.enable = true;
    wl-clipboard.enable = true;
  };
}
