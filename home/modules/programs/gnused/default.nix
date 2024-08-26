{ pkgs, util, ... }:
util.mkProgram {
  name = "gnused";
  hm.home.packages = with pkgs; [ gnused ];
}
