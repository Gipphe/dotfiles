{ util, ... }:
util.mkProgram {
  name = "fd";
  home-manager.programs.fd.enable = true;
}
