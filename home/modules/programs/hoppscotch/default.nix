{ util, pkgs, ... }:
util.mkProgram {
  name = "hoppscotch";
  hm.home.packages = [ pkgs.hoppscotch ];
}
