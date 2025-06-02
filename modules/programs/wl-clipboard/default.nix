{ util, pkgs, ... }:
util.mkProgram {
  name = "wl-clipboard";
  hm.home.packages = [ pkgs.wl-clipboard ];
}
