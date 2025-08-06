{ util, ... }:
util.mkProgram {
  name = "nushell";
  hm.programs.nushell.enable = true;
}
