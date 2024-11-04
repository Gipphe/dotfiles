{ util, pkgs, ... }:
util.mkProgram {
  name = "steam";
  hm.home.packages = [ pkgs.steam ];
  system-darwin.homebrew.casks = [ "steam" ];
}
