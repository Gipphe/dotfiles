{ lib, config, ... }:
{
  options.gipphe.profiles.music.enable = lib.mkEnableOption "music profile";
  config = lib.mkIf config.gipphe.profiles.music.enable {
    gipphe.programs.spotify-player.enable = true;
  };
}
