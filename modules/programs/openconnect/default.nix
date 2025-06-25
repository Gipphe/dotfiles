{ util, pkgs, ... }:
util.mkProgram {
  name = "openconnect";
  hm.home.packages = [ pkgs.openconnect ];
}
