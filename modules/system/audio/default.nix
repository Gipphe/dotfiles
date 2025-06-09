{ util, pkgs, ... }:
util.mkToggledModule [ "system" ] {
  name = "audio";
  system-nixos = {
    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services = {
      pipewire = {
        enable = true;
        audio.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
        wireplumber = {
          enable = true;
          extraConfig.bluetoothEnhancement."monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.codecs" = [
              "sbc"
              "sbc_xq"
              "aac"
              "ldac"
              "aptx"
              "aptx_hd"
            ];
          };
        };
        extraConfig.pipewire."92-low-latency"."context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 32;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 32;
        };
      };
    };
    hardware = {
      pulseaudio.support32Bit = true;
      bluetooth = {
        enable = true;
        powerOnBoot = false;
        package = pkgs.bluez5-experimental;
      };
    };
  };
}
