{
  util,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.pipewire;
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
in
util.mkProgram {
  name = "pipewire";
  options.gipphe.programs.pipewire = {
    higherQuantum.enable = lib.mkEnableOption "higher quantum settings";
  };
  hm.gipphe.core.wm.binds = [
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
  system-nixos.config = lib.mkMerge [
    {
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
    }
    (lib.mkIf cfg.higherQuantum.enable {
      services.pipewire.extraConfig = {
        client."10-resample"."stream.properties"."resample.quality" = 10;
        # higher quantum to fix audio crackling
        pipewire."92-quantum" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 256;
            "default.clock.min-quantum" = 256;
            "default.clock.max-quantum" = 512;
          };
        };
        pipewire-pulse."92-quantum" =
          let
            qr = "256/48000";
          in
          {
            "context.properties" = [
              {
                name = "libpipewire-module-protocol-pulse";
                args = { };
              }
            ];
            "pulse.properties" = lib.genAttrs [
              "pulse.default.req"
              "pulse.min.req"
              "pulse.max.req"
              "pulse.min.quantum"
              "pulse.max.quantum"
            ] (_: qr);
            "stream.properties" = {
              "node.latency" = qr;
            };
          };
      };
    })
  ];
}
