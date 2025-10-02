{ util, pkgs, ... }:
util.mkProgram {
  name = "sd";
  hm.home.packages = [ pkgs.sd ];
}
