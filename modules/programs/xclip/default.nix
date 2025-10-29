{ util, pkgs, ... }:
util.mkProgram {
  name = "xclip";

  hm.home.packages = [ pkgs.xclip ];
}
