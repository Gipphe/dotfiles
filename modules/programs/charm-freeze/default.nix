{ util, pkgs, ... }:
util.mkProgram {
  name = "charm-freeze";
  hm.home.packages = [ pkgs.charm-freeze ];
}
