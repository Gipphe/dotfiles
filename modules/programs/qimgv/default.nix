{ util, pkgs, ... }:
util.mkProgram {
  name = "qimgv";
  hm.home.packages = [ pkgs.qimgv ];
}
