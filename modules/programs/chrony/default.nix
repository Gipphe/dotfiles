{ util, ... }:
util.mkProgram {
  name = "chrony";
  system-nixos.services.chrony.enable = true;
}
