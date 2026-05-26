{ util, ... }:
util.mkProgram {
  name = "jq";
  homeManager.programs.jq.enable = true;
}
