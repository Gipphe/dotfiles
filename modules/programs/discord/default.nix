{ util, pkgs, ... }:
util.mkProgram {
  name = "discord";
  hm.home.packages = [ pkgs.discord ];
}
