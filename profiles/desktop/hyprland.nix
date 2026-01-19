{
  util,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.profiles.desktop.hyprland;
  useDefault = !(cfg.caelestia.enable || cfg.noctalia.enable);
in
util.mkToggledModule [ "profiles" "desktop" ] {
  name = "hyprland";
  options.gipphe.profiles.desktop.hyprland = {
    caelestia.enable = lib.mkEnableOption "caelestia shell";
    noctalia.enable = lib.mkEnableOption "noctalia shell";
  };
  shared.gipphe = {
    system.xdg.enable = true;
    programs = lib.mkMerge [
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

        dolphin.enable = true;

        # Pinentry
        pinentry-curses.enable = true;

        yazi.enable = true;
      }

      (lib.mkIf useDefault {
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

        # Bars
        eww.enable = true;
        eww.dev = true;
        waybar.enable = false;
        quickshell.enable = false;
        quickshell.dev = true;
      })

      (lib.mkIf cfg.caelestia.enable {
        wezterm.enable = true;
        caelestia-shell.enable = true;
      })

      (lib.mkIf cfg.noctalia.enable {
        grimblast.enable = true;
        noctalia-shell.enable = true;
        wezterm.enable = true;
      })
    ];
  };
}
