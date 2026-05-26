{ util, pkgs, ... }:
util.mkProgram {
  name = "signal";
  homeManager = {
    home.packages = [ pkgs.signal-desktop ];
  };
}
