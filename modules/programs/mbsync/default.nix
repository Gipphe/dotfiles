{ util, ... }:
util.mkProgram {
  name = "mbsync";
  homeManager = {
    services.mbsync.enable = true;
  };
}
