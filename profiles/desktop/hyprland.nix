{ util, ... }:
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

    plymouth.enable = true;

    # Launchers
    rofi.enable = false;
    walker.enable = true;

    # Notifications
    dunst.enable = false;
    mako.enable = false;
    swaync.enable = true;

    networkmanagerapplet.enable = false;

    # Screenshotting and recording
    wf-recorder.enable = true;
    grimblast.enable = true;

    # Clipboard
    wl-clipboard.enable = true;
    cliphist.enable = true;
    clipse.enable = false;

    # Pinentry
    pinentry-curses.enable = true;
    wayprompt.enable = false;

    # File manager
    yazi.enable = true;

    # Bars
    mechabar.enable = false;
    eww.enable = true;
    eww.dev = true;
    quickshell.enable = false;
    waybar.enable = false;
  };
}
