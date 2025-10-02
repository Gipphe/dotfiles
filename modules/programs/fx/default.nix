{ util, pkgs, ... }:
util.mkProgram {
  name = "fx";
  hm.home.packages = [ pkgs.fx ];
}
