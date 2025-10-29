{ pkgs, util, ... }:
util.mkProgram {
  name = "mpc-cli";
  hm.home.packages = [ pkgs.mpc-cli ];
}
