{ util, ... }:
util.mkProgram {
  name = "ripgrep";
  hm.programs.ripgrep.enable = true;
}
