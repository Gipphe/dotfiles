{ lib, config, ... }:
{
  options.gipphe.profiles.audio.enable = lib.mkEnableOption "audio profile";
  config = lib.mkIf config.gipphe.profiles.audio.enable {
    gipphe.programs = {
      bcn.enable = true;
      cava.enable = true;
      mpc-cli.enable = true;
    };
  };
}
