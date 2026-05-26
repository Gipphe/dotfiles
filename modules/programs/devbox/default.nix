{ util, pkgs, ... }:
util.mkProgram {
  name = "devbox";
  homeManager.home.packages = [ pkgs.devbox ];
}
