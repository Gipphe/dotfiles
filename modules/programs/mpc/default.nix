{ pkgs, util, ... }:
util.mkProgram {
  name = "mpc";
  homeManager.home.packages = [ pkgs.mpc ];
}
