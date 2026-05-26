{ util, pkgs, ... }:
util.mkProgram {
  name = "curl";
  homeManager.home.packages = [ pkgs.curlFull ];
}
