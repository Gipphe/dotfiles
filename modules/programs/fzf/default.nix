{ util, ... }:
util.mkProgram {
  name = "fzf";
  homeManager.programs.fzf.enable = true;
}
