{ util, ... }:
util.mkProgram {
  name = "tumbler";
  system-nixos.services.tumbler.enable = true;
}
