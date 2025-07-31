{ util, ... }:
util.mkProfile "desktop-hyprland" {
  gipphe = {
    environment = {
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

      };
      display.enable = true;
      wayland.enable = true;
    };
    programs = {
      networkmanagerapplet.enable = false;
      wf-recorder.enable = true;
      wl-clipboard.enable = true;
    };

    # Bars
    desktop.hyprland.ashell.enable = false;
    desktop.hyprland.mechabar.enable = false;
    programs.eww.enable = true;
    desktop.hyprland.waybar.enable = false;
  };
}
