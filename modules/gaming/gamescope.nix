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
        capSysNice = false;
        args = [
          "-f"
          "--rt"
          "--expose-wayland"
          "--mangoapp"
          # "--hdr-enabled"
          # "--hdr-itm-enable"
          "--hide-cursor-delay"
          "3000"
          "--fade-out-duration"
          "200"
          "--xwayland-count"
          "2"
        ]
        ++ host.settings.gaming.gamescope.args;
        env = {
          # DXVK_HDR = "1";
          ENABLE_GAMESCOPE_WSI = "1";
          # PROTON_ENABLE_HDR = "1";
        };
      };
    };
  };
}
