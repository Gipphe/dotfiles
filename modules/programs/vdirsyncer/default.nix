{ util, ... }:
util.mkProgram {
  name = "vdirsyncer";
  homeManager = {
    programs.vdirsyncer.enable = true;
    services.vdirsyncer.enable = true;
  };
}
