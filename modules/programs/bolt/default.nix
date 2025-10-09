{ util, pkgs, ... }:
util.mkProgram {
  name = "bolt-launcher";
  hm.home.packages = [ pkgs.bolt-launcher ];
}
