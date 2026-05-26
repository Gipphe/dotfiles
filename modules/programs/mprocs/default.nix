{ util, pkgs, ... }:
util.mkProgram {
  name = "mprocs";
  homeManager.home.packages = [ pkgs.mprocs ];
}
