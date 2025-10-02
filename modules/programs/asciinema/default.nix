{ util, pkgs, ... }:
util.mkProgram {
  name = "asciinema";
  hm.home.packages = [ pkgs.asciinema ];
}
