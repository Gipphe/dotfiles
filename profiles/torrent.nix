{ util, ... }:
util.mkProfile {
  name = "torrent";
  shared.gipphe.programs = {
    rtorrent.enable = true;
  };
}
