{ util, pkgs, ... }:
util.mkProgram {
  name = "kubectx";
  homeManager = {
    home.packages = [ pkgs.kubectx ];
    programs.nushell.settings.abbreviations = {
      kcx = "kubectx";
      kn = "kubens";
    };
  };
}
