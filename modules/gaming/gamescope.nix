{ lib, ... }:
{
  den.aspects.gaming.gamescope = {
    settings.args = lib.mkOption {
      type = with lib.types; listOf str;
      description = "Args to pass to gamescope";
      default = [ ];
    };
    nixos = { host }: {
      programs.gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--fullscreen"
          "--rt"
          "--expose-wayland"
          "--hide-cursor-delay"
          "3000"
        ]
        ++ host.settings.gaming.gamescope.args;
        env = {
          ENABLE_GAMESCOPE_WSI = "1";
        };
      };
    };
  };
}
