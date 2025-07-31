{ util, ... }:
util.mkProfile "desktop-hyprland" {
  gipphe = {
    environment = {
      desktop.hyprland = {
        enable = true;

        # Notifications
        swaync.enable = true;

        # Launchers
        rofi.enable = false;
        walker.enable = true;

      };
      display.enable = true;
      wayland.enable = true;
    };
    programs = {
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      hyprpolkitagent.enable = true;
      wlogout.enable = false;

      # Notifications
      dunst.enable = false;
      mako.enable = false;

      networkmanagerapplet.enable = false;
      wf-recorder.enable = true;
      wl-clipboard.enable = true;

      # File manager
      yazi.enable = true;
      yazi.hyprland.enable = true;

      # Bars
      mechabar.enable = false;
      eww.enable = true;
      waybar.enable = false;
    };
  };
}
