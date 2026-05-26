{ util, ... }:
util.mkProgram {
  name = "k9s";
  homeManager.programs.k9s.enable = true;
}
