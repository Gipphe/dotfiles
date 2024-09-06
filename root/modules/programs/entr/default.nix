{ util, pkgs, ... }:
util.mkProgram {
  name = "entr";
  hm.home.packages = [ pkgs.entr ];
}
