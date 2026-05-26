{ util, pkgs, ... }:
util.mkProgram {
  name = "dolphin";
  homeManager.home.packages = [ pkgs.kdePackages.dolphin ];
}
