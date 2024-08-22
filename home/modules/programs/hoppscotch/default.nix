{ util, pkgs, ... }:
util.mkProgram {
  hm = {
    home.packages = [ pkgs.hoppscotch ];
  };
}
