{ util, pkgs, ... }:
util.mkProgram {
  name = "devbox";
  home-manager.home.packages = [ pkgs.devbox ];
}
