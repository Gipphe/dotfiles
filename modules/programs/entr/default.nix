{ util, pkgs, ... }:
util.mkProgram {
  name = "entr";
  home-manager.home.packages = [ pkgs.entr ];
}
