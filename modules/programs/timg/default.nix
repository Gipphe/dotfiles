{ util, pkgs, ... }:
util.mkProgram {
  name = "timg";
  home-manager.home.packages = [ pkgs.timg ];
}
