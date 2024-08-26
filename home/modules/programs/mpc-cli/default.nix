{ pkgs, util, ... }:
util.mkProgram {
  name = "mpc-cli";
  hm.home.packages = with pkgs; [ mpc-cli ];
}
