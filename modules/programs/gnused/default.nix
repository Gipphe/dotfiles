{ pkgs, util, ... }:
util.mkProgram {
  name = "gnused";
  home-manager.home.packages = [ pkgs.gnused ];
}
