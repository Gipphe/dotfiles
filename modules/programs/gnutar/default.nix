{ util, pkgs, ... }:
util.mkProgram {
  name = "gnutar";

  homeManager.home.packages = [ pkgs.gnutar ];
}
