{ util, pkgs, ... }:
util.mkProgram {
  name = "xclip";

  hm.home.packages = with pkgs; [ xclip ];
}
