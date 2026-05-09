{ util, pkgs, ... }:
util.mkProgram {
  name = "lazydocker";
  home-manager.home.packages = [ pkgs.lazydocker ];
}
