{ pkgs, util, ... }:
util.mkProgram {
  name = "mpc";
  hm.home.packages = [ pkgs.mpc ];
}
