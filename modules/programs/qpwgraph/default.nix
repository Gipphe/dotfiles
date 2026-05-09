{ util, pkgs, ... }:
util.mkProgram {
  name = "qpwgraph";
  home-manager = {
    home.packages = [ pkgs.qpwgraph ];
  };
}
