{ util, pkgs, ... }:
util.mkProgram {
  name = "xclip";

  homeManager.home.packages = [ pkgs.xclip ];
}
