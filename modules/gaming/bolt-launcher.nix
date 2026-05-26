{ util, pkgs, ... }:
util.mkGaming {
  name = "bolt-launcher";
  home-manager.home.packages = [ pkgs.bolt-launcher ];
}
