{ util, pkgs, ... }:
util.mkProgram {
  name = "serpl";
  hm.home.packages = [ pkgs.serpl ];
}
