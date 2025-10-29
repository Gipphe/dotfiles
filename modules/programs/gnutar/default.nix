{ util, pkgs, ... }:
util.mkProgram {
  name = "gnutar";

  hm.home.packages = [ pkgs.gnutar ];
}
