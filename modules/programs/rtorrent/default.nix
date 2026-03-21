{ util, ... }:
util.mkProgram {
  name = "rtorrent";
  hm = {
    programs.rtorrent.enable = true;
  };
}
