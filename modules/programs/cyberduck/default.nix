{ util, pkgs, ... }:
util.mkProgram {
  name = "cyberduck";
  homeManager.home.packages = [ pkgs.cyberduck ];
}
