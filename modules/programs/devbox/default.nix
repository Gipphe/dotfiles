{ util, pkgs, ... }:
util.mkProgram {
  name = "devbox";
  hm.home.packages = [ pkgs.devbox ];
}
