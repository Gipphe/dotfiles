{ util, pkgs, ... }:
util.mkProgram {
  name = "make";
  hm.home.packages = [ pkgs.gnumake ];
}
