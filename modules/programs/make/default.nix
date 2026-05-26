{ util, pkgs, ... }:
util.mkProgram {
  name = "make";
  homeManager.home.packages = [ pkgs.gnumake ];
}
