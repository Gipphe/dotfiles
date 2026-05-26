{ util, pkgs, ... }:
util.mkProgram {
  name = "fastgron";
  homeManager = {
    home.packages = [ pkgs.fastgron ];
    programs.fish.shellAbbrs.gron = "fastgron";
  };
}
