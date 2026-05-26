{ util, ... }:
util.mkProgram {
  name = "cliphist";
  homeManager.services.cliphist = {
    enable = true;
  };
}
