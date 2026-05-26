{ util, pkgs, ... }:
util.mkProgram {
  name = "qpwgraph";
  homeManager = {
    home.packages = [ pkgs.qpwgraph ];
  };
}
