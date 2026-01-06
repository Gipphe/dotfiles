{ pkgs, util, ... }:
util.mkProgram {
  name = "hygg";
  hm.home.packages = [ pkgs.hygg ];
}
