{ util, ... }:
util.mkProgram {
  name = "localsend";
  system-nixos.programs.localsend.enable = true;
}
