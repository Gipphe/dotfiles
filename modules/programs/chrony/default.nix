{ util, ... }:
util.mkProgram {
  name = "chrony";
  nixos.services.chrony.enable = true;
}
