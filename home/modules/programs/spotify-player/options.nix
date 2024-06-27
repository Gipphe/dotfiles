{ lib, ... }:
{
  options.gipphe.programs.spotify-player.enable = lib.mkEnableOption "spotify-player";
}
