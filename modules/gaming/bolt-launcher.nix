{ util, pkgs, ... }:
util.mkGaming {
  name = "bolt-launcher";
  homeManager.home.packages = [ pkgs.bolt-launcher ];
}
