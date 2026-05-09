{ util, pkgs, ... }:
util.mkProgram {
  name = "make";
  home-manager.home.packages = [ pkgs.gnumake ];
}
