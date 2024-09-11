{ util, pkgs, ... }:
util.mkProgram {
  name = "discord";
  hm.home.packages = with pkgs; [ discord ];
}
