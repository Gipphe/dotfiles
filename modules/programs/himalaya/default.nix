{ util, ... }:
util.mkProgram {
  name = "himalaya";
  homeManager = {
    programs.himalaya = {
      enable = true;
    };
  };
}
