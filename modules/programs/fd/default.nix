{ util, ... }:
util.mkProgram {
  name = "fd";
  homeManager.programs.fd.enable = true;
}
