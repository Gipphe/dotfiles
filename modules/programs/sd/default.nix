{ util, pkgs, ... }:
util.mkProgram {
  name = "sd";
  home-manager.home.packages = [ pkgs.sd ];
}
