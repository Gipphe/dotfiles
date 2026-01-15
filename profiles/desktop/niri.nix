{ util, ... }:
util.mkToggledModule [ "profiles" "desktop" ] {
  name = "niri";
  shared.gipphe = {
    system.xdg.enable = true;
    programs = {
      # hypridle.enable = true;
      niri.enable = true;
      # hyprlock.enable = true;
      # hyprpaper.enable = true;

      sddm.enable = true;

      plymouth.enable = true;

      # Launchers
      walker.enable = true;

      # Notifications
      swaync.enable = true;

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
    };
  };
}
