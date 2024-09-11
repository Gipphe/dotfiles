{ util, pkgs, ... }:
util.mkProgram {
  name = "glab";
  hm.home.packages = [ pkgs.glab ];
}
