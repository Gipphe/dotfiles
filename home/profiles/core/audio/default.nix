{ lib, config, ... }:
let
  inherit (config.gipphe.profiles) core;
in
{
  options.gipphe.profiles.core.audio.enable = lib.mkEnableOption "core.audio profile";
  config = lib.mkIf (core.enable && core.audio.enable) {
    gipphe.programs = {
      spotify-player.enable = true;
      bcn.enable = true;
      cava.enable = true;
      mpc-cli.enable = true;
    };
  };
}
