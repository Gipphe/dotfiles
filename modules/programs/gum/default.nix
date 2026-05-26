{ util, pkgs, ... }:
util.mkProgram {
  name = "gum";
  homeManager.home.packages = [ pkgs.gum ];
}
