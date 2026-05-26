{ util, ... }:
util.mkProgram {
  name = "spotify-player";
  homeManager = {
    programs.spotify-player.enable = true;
  };
}
