{ util, ... }:
util.mkProgram {
  name = "jq";
  hm.programs.jq.enable = true;
}
