{ util, ... }:
util.mkProgram {
  name = "restic";
  homeManager = {
    services.restic = {
      enable = true;
    };
  };
}
