{ util, pkgs, ... }:
util.mkProgram {
  name = "ollama";
  home-manager.home.packages = [ pkgs.ollama ];
}
