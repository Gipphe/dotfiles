{ util, config, ... }:
util.mkProgram {
  name = "mpd";
  hm.services.mpd = {
    enable = true;
    musicDirectory = "${config.gipphe.homeDirectory}/Music";
  };
}
