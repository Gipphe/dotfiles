{ util, pkgs, ... }:
util.mkProgram {
  name = "qalculate";
  home-manager = {
    home.packages = [ pkgs.qalculate-qt ];
  };
}
