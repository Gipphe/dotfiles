{ util, pkgs, ... }:
util.mkProgram {
  name = "qalculate";
  hm = {
    home.packages = [ pkgs.qalculate-qt ];
  };
}
