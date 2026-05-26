{ util, pkgs, ... }:
util.mkProgram {
  name = "ollama";
  homeManager.home.packages = [ pkgs.ollama ];
}
