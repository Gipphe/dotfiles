{ pkgs, util, ... }:
util.mkProgram {
  name = "vivaldi";
  hm.home.packages = [ pkgs.vivaldi ];
}
