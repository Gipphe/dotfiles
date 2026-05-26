{ util, lib, ... }:
util.mkToggledModule [ "profiles" "desktop" ] {
  name = "hyprland";
  shared.gipphe = {
    system.xdg.enable = true;
    programs = lib.mkMerge [
      {
        gtk.enable = true;
        hyprland.enable = true;
        hyprpolkitagent.enable = true;
        hypridle.enable = true;
        hyprlock.enable = true;

        ly.enable = false;
        sddm.enable = true;
        greetd.enable = false;

        plymouth.enable = false;

        brightnessctl.enable = true;

        # Screenshotting and recording
        wf-recorder.enable = true;

        # Clipboard
        wl-clipboard.enable = true;
        cliphist.enable = true;
        clipse.enable = false;

        thunar.enable = true;

        # Pinentry
        pinentry-curses.enable = true;

        yazi.enable = true;

        grimblast.enable = true;
        noctalia-shell.enable = true;
        wezterm.enable = true;
      }
    ];
  };
}
