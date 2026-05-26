{ util, ... }:
util.mkProgram {
  name = "kanshi";
  homeManager.services.kanshi = {
    enable = true;
  };
}
