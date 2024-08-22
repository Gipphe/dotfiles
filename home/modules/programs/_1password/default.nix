{ util, pkgs, ... }:
util.mkProgram {
  name = "_1password";
  hm.home.packages = with pkgs; [ _1password ];
}
