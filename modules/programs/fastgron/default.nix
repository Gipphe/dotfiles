{ util, pkgs, ... }:
util.mkProgram {
  name = "fastgron";
  hm = {
    home.packages = [ pkgs.fastgron ];
    wrappers.fish.init.shellAbbrs.gron = "fastgron";
  };
}
