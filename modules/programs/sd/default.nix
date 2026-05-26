{ util, pkgs, ... }:
util.mkProgram {
  name = "sd";
  homeManager.home.packages = [ pkgs.sd ];
}
