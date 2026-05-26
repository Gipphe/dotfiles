{ util, ... }:
util.mkProgram {
  name = "ripgrep";
  homeManager.programs.ripgrep.enable = true;
}
