{ util, pkgs, ... }:
util.mkProgram {
  name = "curl";
  home-manager.home.packages = [ pkgs.curlFull ];
}
