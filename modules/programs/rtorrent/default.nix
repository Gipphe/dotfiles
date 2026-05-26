{ util, ... }:
util.mkProgram {
  name = "rtorrent";
  homeManager = {
    programs.rtorrent.enable = true;
  };
}
