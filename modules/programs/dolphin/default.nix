{ util, pkgs, ... }:
util.mkProgram {
  name = "dolphin";
  home-manager.home.packages = [ pkgs.kdePackages.dolphin ];
}
