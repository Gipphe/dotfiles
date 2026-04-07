{ util, pkgs, ... }:
util.mkProgram {
  name = "kubectx";
  homeManager = {
    home.packages = [ pkgs.kubectx ];
    wrappers.fish.init.shellAbbrs = {
      kcx = "kubectx";
      kn = "kubens";
    };
  };
}
