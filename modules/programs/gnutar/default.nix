{ util, pkgs, ... }:
util.mkProgram {
  name = "gnutar";

  hm.home.packages = with pkgs; [ gnutar ];
}
