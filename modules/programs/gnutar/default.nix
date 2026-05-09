{ util, pkgs, ... }:
util.mkProgram {
  name = "gnutar";

  home-manager.home.packages = [ pkgs.gnutar ];
}
