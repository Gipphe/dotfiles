{ pkgs, util, ... }:
util.mkProgram {
  name = "vulnix";
  hm.home.packages = [ pkgs.vulnix ];
}
