{ util, pkgs, ... }:
util.mkProgram {
  name = "fastgron";
  hm = {
    home.packages = [ pkgs.fastgron ];
    programs.fish.shellAbbrs.gron = "fastgron";
  };
}
