{ util, pkgs, ... }:
util.mkProgram {
  name = "serpl";
  home-manager.home.packages = [ pkgs.serpl ];
}
