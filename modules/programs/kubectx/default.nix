{ util, pkgs, ... }:
util.mkProgram {
  name = "kubectx";
  homeManager = {
    home.packages = [ pkgs.kubectx ];
    gipphe.core.shell.abbrs = {
      kcx = "kubectx";
      kn = "kubens";
    };
  };
}
