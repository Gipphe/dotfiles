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

    ly.enable = true;
    sddm.enable = false;
    greetd.enable = false;

    plymouth.enable = true;

    # Launchers
    walker.enable = true;

    # Notifications
    dunst.enable = false;
    mako.enable = false;
    swaync.enable = true;

    brightnessctl.enable = true;
    networkmanagerapplet.enable = true;

    # Screenshotting and recording
    wf-recorder.enable = true;
    grimblast.enable = true;

    # Clipboard
    wl-clipboard.enable = true;
    cliphist.enable = true;
    clipse.enable = false;

    # Pinentry
    pinentry-curses.enable = true;

    # File manager
    yazi.enable = true;
    dolphin.enable = true;

    # Bars
    eww.enable = true;
    eww.dev = true;
    quickshell.enable = false;
    waybar.enable = false;
  };
}
