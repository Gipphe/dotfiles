{ util, pkgs, ... }:
util.mkProgram {
  name = "lazydocker";
  homeManager.home.packages = [ pkgs.lazydocker ];
}
