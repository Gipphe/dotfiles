{ util, pkgs, ... }:
util.mkProgram {
  name = "fastgron";
  homeManager = {
    home.packages = [ pkgs.fastgron ];
    gipphe.core.shell.abbrs.gron = "fastgron";
  };
}
