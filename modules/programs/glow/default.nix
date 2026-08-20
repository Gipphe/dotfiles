{ util, ... }:
util.mkProgram {
  name = "glow";
  homeManager = {
    programs.nushell.settings.abbreviations.glow = ", glow";
  };
}
