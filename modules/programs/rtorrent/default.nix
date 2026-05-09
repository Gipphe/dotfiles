{ util, ... }:
util.mkProgram {
  name = "rtorrent";
  home-manager = {
    programs.rtorrent.enable = true;
  };
}
