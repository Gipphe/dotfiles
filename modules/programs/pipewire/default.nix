{ util, pkgs, ... }:
let
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
in
util.mkProgram {
  name = "pipewire";
  hm.wayland.windowManager.hyprland.settings.bind = [
    ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
    ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ", XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
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
