{ util, pkgs, ... }:
util.mkProgram {
  name = "procs";
  home-manager.home.packages = [ pkgs.procs ];
}
