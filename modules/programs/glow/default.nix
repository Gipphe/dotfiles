{ util, ... }:
util.mkProgram {
  name = "glow";
  homeManager = {
    gipphe.core.shell.abbrs.glow = ", glow";
  };
}
