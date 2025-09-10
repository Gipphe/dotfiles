{ util, ... }:
util.mkProgram {
  name = "seahorse";
  system-nixos.programs.seahorse.enable = true;
}
