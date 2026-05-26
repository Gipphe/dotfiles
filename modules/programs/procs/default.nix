{ util, pkgs, ... }:
util.mkProgram {
  name = "procs";
  homeManager.home.packages = [ pkgs.procs ];
}
