{ util, pkgs, ... }:
util.mkProgram {
  name = "dua";
  homeManager.home.packages = [ pkgs.dua ];
}
