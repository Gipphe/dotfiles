{ util, ... }:
util.mkProfile "desktop-hyprland" {
  gipphe.environment = {
    desktop.hyprland = {
      enable = true;
      filemanager.enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      hyprpolkitagent.enable = true;
      wlogout.enable = false;

      # Notifications
      dunst.enable = false;
      mako.enable = false;
      swaync.enable = true;

      # Launchers
      rofi.enable = false;
      walker.enable = true;

      # Bars
      ashell.enable = false;
      mechabar.enable = false;
      eww.enable = true;
      waybar.enable = false;
    };
    display.enable = true;
    wayland.enable = true;
  };
  gipphe.programs = {
    networkmanagerapplet.enable = false;
    wl-clipboard.enable = true;
  };
}
