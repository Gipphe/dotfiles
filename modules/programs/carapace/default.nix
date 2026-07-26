{ util, ... }:
util.mkProgram {
  name = "carapace";
  homeManager = {
    programs.carapace.enable = true;
  };
}
