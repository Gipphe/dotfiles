{ util, ... }:
util.mkProgram {
  name = "thefuck";
  hm.programs.thefuck.enable = true;
}
