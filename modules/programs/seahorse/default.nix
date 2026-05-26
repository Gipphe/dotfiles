{ util, ... }:
util.mkProgram {
  name = "seahorse";
  nixos.programs.seahorse.enable = true;
}
