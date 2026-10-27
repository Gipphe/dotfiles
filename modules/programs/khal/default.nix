{ util, ... }:
util.mkProgram {
  name = "khal";
  homeManager = {
    programs.khal.enable = true;
  };
}
