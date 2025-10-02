{ util, pkgs, ... }:
util.mkProgram {
  name = "ollama";
  hm.home.packages = [ pkgs.ollama ];
}
