{ util, pkgs, ... }:
util.mkProgram {
  name = "heroic";
  hm.home.packages = [ pkgs.heroic ];
}
