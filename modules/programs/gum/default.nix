{ util, pkgs, ... }:
util.mkProgram {
  name = "gum";
  home-manager.home.packages = [ pkgs.gum ];
}
