{ util, config, ... }:
util.mkProgram {
  name = "mpd";
  home-manager.services.mpd = {
    enable = true;
    musicDirectory = "${config.gipphe.homeDirectory}/Music";
  };
}
