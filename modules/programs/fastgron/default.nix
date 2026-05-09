{ util, pkgs, ... }:
util.mkProgram {
  name = "fastgron";
  home-manager = {
    home.packages = [ pkgs.fastgron ];
    programs.fish.shellAbbrs.gron = "fastgron";
  };
}
