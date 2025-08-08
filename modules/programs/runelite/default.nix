{ util, pkgs, ... }:
util.mkProgram {
  name = "runelite";
  hm.home.packages = [ pkgs.runelite ];
}
