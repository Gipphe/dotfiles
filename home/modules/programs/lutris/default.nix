{ pkgs, util, ... }:
util.mkProgram {
  name = "lutris";
  hm.home.packages = with pkgs; [ lutris ];
}
