{ util, pkgs, ... }:
util.mkProgram {
  name = "fastgron";
  homeManager = {
    home.packages = [ pkgs.fastgron ];
    wrappers.fish.init.shellAbbrs.gron = "fastgron";
  };
}
