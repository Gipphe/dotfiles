{ pkgs, util, ... }:
util.mkProgram {
  name = "hygg";
  home-manager.home.packages = [ pkgs.hygg ];
}
