{ util, ... }:
util.mkProgram {
  name = "discord";
  homeManager = {
    programs.discord = {
      enable = true;
    };
  };
}
