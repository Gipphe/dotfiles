{
  util,
  lib,
  config,
  ...
}:
util.mkToggledModule [ "profiles" "desktop" ] {
  name = "hyprland";
  options.gipphe.profiles.desktop.hyprland.caelestia.enable = lib.mkEnableOption "caelestia shell";
  shared.gipphe.programs = lib.mkMerge [
    {
      hyprland.enable = true;
      hyprpolkitagent.enable = true;

      ly.enable = false;
      sddm.enable = true;
      greetd.enable = false;

      plymouth.enable = true;

      brightnessctl.enable = true;

      # Screenshotting and recording
      wf-recorder.enable = true;

      # Clipboard
      wl-clipboard.enable = true;
      cliphist.enable = true;
      clipse.enable = false;

      # Pinentry
      pinentry-curses.enable = true;

      yazi.enable = true;
    }

    (lib.mkIf (!config.gipphe.profiles.desktop.hyprland.caelestia.enable) {
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;

      # Launchers
      walker.enable = true;

      # Notifications
      dunst.enable = false;
      mako.enable = false;
      swaync.enable = true;

      networkmanagerapplet.enable = true;
      grimblast.enable = true;
      dolphin.enable = true;

      # Bars
      eww.enable = false;
      eww.dev = true;
    })

    (lib.mkIf config.gipphe.profiles.desktop.hyprland.caelestia.enable {
      wezterm.enable = true;
      caelestia-shell.enable = true;
    })
  ];
}
