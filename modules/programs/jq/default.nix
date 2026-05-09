{ util, ... }:
util.mkProgram {
  name = "jq";
  home-manager.programs.jq.enable = true;
}
