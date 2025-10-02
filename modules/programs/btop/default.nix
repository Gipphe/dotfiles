{ util, ... }:
util.mkProgram {
  name = "btop";
  hm.programs.btop.enable = true;
}
