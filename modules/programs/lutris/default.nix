{ pkgs, util, ... }:
util.mkProgram {
  name = "lutris";
  hm.home.packages = [ pkgs.lutris ];
}
