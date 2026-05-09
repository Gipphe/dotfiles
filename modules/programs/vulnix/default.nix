{ pkgs, util, ... }:
util.mkProgram {
  name = "vulnix";
  home-manager.home.packages = [ pkgs.vulnix ];
}
