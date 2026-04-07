{ util, pkgs, ... }:
util.mkProgram {
  name = "kubectx";
  hm = {
    home.packages = [ pkgs.kubectx ];
    wrappers.fish.init.shellAbbrs = {
      kcx = "kubectx";
      kn = "kubens";
    };
  };
}
