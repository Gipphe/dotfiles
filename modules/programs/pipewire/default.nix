{
  util,
  config,
  lib,
  pkgs,
  ...
}:
let
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
in
util.mkProgram {
  name = "pipewire";
  options.gipphe.programs.pipewire = {
    hyprland.enable = lib.mkEnableOption "Hyprland integration" // {
      default = config.programs.hyprland.enable;
      defaultText = "config.programs.hyprland.enable";
    };
  };
  gipphe.core.wm.binds = [
    {
      key = "XF86AudioRaiseVolume";
      action.spawn = "${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
    }
    {
      key = "XF86AudioLowerVolume";
      action.spawn = "${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
    }
    {
      key = "XF86AudioMute";
      action.spawn = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
    }
    {
      key = "XF86AudioMicMute";
      action.spawn = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
    }
  ];
  system-nixos = {
    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services = {
      pipewire = {
        enable = true;
        audio.enable = true;
        alsa.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
    };
  };
}
