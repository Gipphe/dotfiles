{ util, pkgs, ... }:
util.mkProgram {
  name = "cyberduck";
  home-manager.home.packages = [ pkgs.cyberduck ];
}
