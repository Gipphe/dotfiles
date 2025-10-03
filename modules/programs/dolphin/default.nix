{ util, pkgs, ... }:
util.mkProgram {
  name = "dolphin";
  hm.home.packages = [ pkgs.kdePackages.dolphin ];
}
