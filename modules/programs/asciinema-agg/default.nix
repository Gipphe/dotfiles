{ util, pkgs, ... }:
util.mkProgram {
  name = "asciinema-agg";
  home-manager.home.packages = [ pkgs.asciinema-agg ];
}
