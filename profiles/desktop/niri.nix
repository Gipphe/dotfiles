{ util, ... }:
util.mkToggledModule [ "profiles" "desktop" ] {
  name = "niri";
  shared.gipphe = {
    system.xdg.enable = true;
    programs = {
      niri.enable = true;

      # polkit agent
      soteria.enable = true;
      sddm.enable = true;
      plymouth.enable = true;

      brightnessctl.enable = true;

      # Screenshotting and recording
      wf-recorder.enable = true;

      # Clipboard
      wl-clipboard.enable = true;
      cliphist.enable = true;
      clipse.enable = false;

      dolphin.enable = true;

      # Pinentry
      pinentry-curses.enable = true;

      yazi.enable = true;

      # TODO: Niri comes with its own screenshotting capabilities.
      # grimblast.enable = true;
      noctalia-shell.enable = true;
      wezterm.enable = true;
    };
  };
}
