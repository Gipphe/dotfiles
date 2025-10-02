{ util, pkgs, ... }:
util.mkProgram {
  name = "gum";
  hm.home.packages = [ pkgs.gum ];
}
