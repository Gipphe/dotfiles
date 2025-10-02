{ util, pkgs, ... }:
util.mkProgram {
  name = "cyberduck";
  hm.home.packages = [ pkgs.cyberduck ];
}
