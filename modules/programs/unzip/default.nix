{ util, pkgs, ... }:
util.mkProgram {
  name = "unzip";
  hm.home.packages = [ pkgs.unzip ];
}
