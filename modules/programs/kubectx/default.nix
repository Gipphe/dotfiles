{ util, pkgs, ... }:
util.mkProgram {
  name = "kubectx";
  home-manager = {
    home.packages = [ pkgs.kubectx ];
    programs.fish.shellAbbrs = {
      kcx = "kubectx";
      kn = "kubens";
    };
  };
}
