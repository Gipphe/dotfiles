{ util, ... }:
util.mkProgram {
  name = "localsend";
  nixos.programs.localsend.enable = true;
}
