{ util, ... }:
util.mkProgram {
  name = "k9s";
  hm.programs.k9s.enable = true;
}
