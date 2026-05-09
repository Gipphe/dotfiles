{ util, pkgs, ... }:
util.mkProgram {
  name = "xclip";

  home-manager.home.packages = [ pkgs.xclip ];
}
