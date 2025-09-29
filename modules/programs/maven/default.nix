{ util, pkgs, ... }:
util.mkProgram {
  name = "maven";
  hm.home.packages = [ pkgs.maven ];
}
