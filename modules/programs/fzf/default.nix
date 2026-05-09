{ util, ... }:
util.mkProgram {
  name = "fzf";
  home-manager.programs.fzf.enable = true;
}
