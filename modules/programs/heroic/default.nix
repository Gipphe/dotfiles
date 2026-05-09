{ util, pkgs, ... }:
util.mkProgram {
  name = "heroic";
  home-manager.home.packages = [ pkgs.heroic ];
}
