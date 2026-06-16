{ util, pkgs, ... }:
util.mkProgram {
  name = "umu-launcher";
  homeManager = {
    home.packages = [ pkgs.umu-launcher ];
  };
}
