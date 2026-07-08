{ util, config, ... }:
util.mkToggledModule [ "hardware" "peripheral" "xbox" "one" ] {
  name = "controller";
  nixos = {
    hardware.bluetooth = {
      settings.General = {
        # Show battery
        experimental = true;

        # https://www.reddit.com/r/NixOS/comments/1ch5d2p/comment/lkbabax/
        # for pairing bluetooth controller
        Privacy = "device";
        JustWorksRepairing = "always";
        Class = "0x000100";
        FastConnectable = true;
      };
    };
    hardware.xpadneo.enable = true;

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
      extraModprobeConfig = ''
        options bluetooth disable_ertm=Y
      '';
    };
  };
}
