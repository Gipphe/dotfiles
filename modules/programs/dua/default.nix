{ util, pkgs, ... }:
util.mkProgram {
  name = "dua";
  home-manager.home.packages = [ pkgs.dua ];
}
