{ util, ... }:
util.mkProgram {
  name = "glow";
  homeManager = {
    programs.fish.shellAbbrs.glow = ", glow";
  };
}
