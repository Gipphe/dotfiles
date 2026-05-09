{ util, ... }:
util.mkProgram {
  name = "spotify-player";
  home-manager = {
    programs.spotify-player.enable = true;
  };
}
