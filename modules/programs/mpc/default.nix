{ pkgs, util, ... }:
util.mkProgram {
  name = "mpc";
  home-manager.home.packages = [ pkgs.mpc ];
}
