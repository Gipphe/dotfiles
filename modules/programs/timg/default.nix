{ util, pkgs, ... }:
util.mkProgram {
  name = "timg";
  hm.home.packages = [ pkgs.timg ];
}
