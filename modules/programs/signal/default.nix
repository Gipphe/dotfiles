{ util, pkgs, ... }:
util.mkProgram {
  name = "signal";
  home-manager = {
    home.packages = [ pkgs.signal-desktop ];
  };
}
