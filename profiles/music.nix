{ util, ... }:
util.mkProfile "music" {
  # Currently broken.
  gipphe.programs.spotify-player.enable = false;
}
