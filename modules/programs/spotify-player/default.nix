{ util, ... }:
util.mkProgram {
  name = "spotify-player";
  hm = {
    programs.spotify-player.enable = true;
  };
}
