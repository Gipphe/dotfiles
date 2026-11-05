{ den, ... }:
{
  den.aspects.profiles.desktop.hyprland.includes = [
    den.aspects.system.xdg

    den.aspects.programs.hyprland
    den.aspects.programs.hyprpolkitagent
    # Try noctalia's idle daemon
    # den.aspects.programs.hypridle
    den.aspects.programs.hyprlock

    # den.aspects.programs.ly
    den.aspects.programs.sddm
    # den.aspects.programs.greetd

    # den.aspects.programs.plymouth

    den.aspects.programs.brightnessctl

    # Screenshotting and recording
    den.aspects.programs.wf-recorder
    den.aspects.programs.gpu-screen-recorder

    # Clipboard
    den.aspects.programs.wl-clipboard
    # den.aspects.programs.cliphist
    # den.aspects.programs.clipse

    den.aspects.programs.dolphin
    # den.aspects.programs.thunar

    # Pinentry
    den.aspects.programs.pinentry-curses

    den.aspects.programs.yazi

    den.aspects.programs.grimblast
    den.aspects.programs.noctalia
    den.aspects.programs.variety
    den.aspects.programs.wezterm
  ];
}
