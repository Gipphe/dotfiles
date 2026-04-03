{ util, pkgs, ... }:
util.mkProgram {
  name = "qpwgraph";
  hm = {
    home.packages = [ pkgs.qpwgraph ];
  };
}
