{ util, pkgs, ... }:
util.mkProgram {
  name = "kubectx";
  hm = {
    home.packages = [ pkgs.kubectx ];
    programs.fish.shellAbbrs = {
      kcx = "kubectx";
      kn = "kubens";
    };
  };
}
