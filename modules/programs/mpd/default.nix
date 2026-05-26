{ util, config, ... }:
util.mkProgram {
  name = "mpd";
  homeManager.services.mpd = {
    enable = true;
    musicDirectory = "${config.gipphe.homeDirectory}/Music";
  };
}
