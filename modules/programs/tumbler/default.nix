{ util, ... }:
util.mkProgram {
  name = "tumbler";
  nixos.services.tumbler.enable = true;
}
