{ util, pkgs, ... }:
util.mkProgram {
  name = "mprocs";
  hm.home.packages = [ pkgs.mprocs ];
}
