{ util, lib, ... }:
util.mkToggledModule [ "profiles" "desktop" ] {
  name = "hyprland";
  shared.gipphe.programs = {
    hypridle.enable = true;
    hyprland.enable = true;
    hyprlock.enable = true;
    hyprpaper.enable = true;
    hyprpolkitagent.enable = true;
    wlogout.enable = false;

    sddm.enable = true;
    greetd.enable = false;

    # Launchers
    rofi.enable = false;
    walker = {
      enable = true;
      hyprland.enable = true;
    };

    # Notifications
    dunst.enable = false;
    mako.enable = false;
    swaync.enable = true;

    networkmanagerapplet.enable = false;
    wf-recorder.enable = true;
    wl-clipboard.enable = true;
    grimblast.enable = true;
    clipse.enable = true;
    wayprompt.enable = true;

    # File manager
    yazi = {
      enable = true;
      hyprland.enable = true;
      default = lib.mkDefault true;
    };

    # Bars
    mechabar.enable = false;
    eww.enable = true;
    waybar.enable = false;
  };
}
