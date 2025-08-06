{ util, pkgs, ... }:
util.mkProgram {
  name = "fastgron";
  hm = {
    home.packages = with pkgs; [ fastgron ];
    programs.fish.shellAbbrs.gron = "fastgron";
  };
}
