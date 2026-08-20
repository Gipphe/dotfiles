{ util, pkgs, ... }:
util.mkProgram {
  name = "fastgron";
  homeManager = {
    home.packages = [ pkgs.fastgron ];
    programs.nushell.settings.abbreviations.gron = "fastgron";
  };
}
