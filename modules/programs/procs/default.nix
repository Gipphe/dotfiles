{ util, pkgs, ... }:
util.mkProgram {
  name = "procs";
  hm.home.packages = [ pkgs.procs ];
}
