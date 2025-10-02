{ util, pkgs, ... }:
util.mkProgram {
  name = "lazydocker";
  hm.home.packages = [ pkgs.lazydocker ];
}
