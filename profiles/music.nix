{ util, ... }:
util.mkProfile {
  name = "music";
  # Currently broken.
  shared.gipphe.programs.spotify-player.enable = false;
}
