{ util, ... }:
util.mkProgram {
  name = "fzf";
  hm.programs.fzf.enable = true;
}
