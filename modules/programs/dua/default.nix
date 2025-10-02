{ util, pkgs, ... }:
util.mkProgram {
  name = "dua";
  hm.home.packages = [ pkgs.dua ];
}
