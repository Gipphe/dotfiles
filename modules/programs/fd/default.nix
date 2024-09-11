{ util, ... }:
util.mkProgram {
  name = "fd";
  hm.programs.fd.enable = true;
}
