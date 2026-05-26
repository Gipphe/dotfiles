{ util, pkgs, ... }:
util.mkProgram {
  name = "kubectx";
  homeManager = {
    home.packages = [ pkgs.kubectx ];
    programs.fish.shellAbbrs = {
      kcx = "kubectx";
      kn = "kubens";
    };
  };
}
