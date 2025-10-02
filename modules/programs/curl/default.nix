{ util, pkgs, ... }:
util.mkProgram {
  name = "curl";
  hm.home.packages = [ pkgs.curlFull ];
}
