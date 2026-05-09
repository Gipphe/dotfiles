{ util, pkgs, ... }:
util.mkProgram {
  name = "bolt-launcher";
  home-manager.home.packages = [ pkgs.bolt-launcher ];
}
