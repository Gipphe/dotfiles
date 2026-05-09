{ util, pkgs, ... }:
util.mkProgram {
  name = "mprocs";
  home-manager.home.packages = [ pkgs.mprocs ];
}
