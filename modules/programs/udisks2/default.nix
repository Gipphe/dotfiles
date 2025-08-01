{ util, ... }:
util.mkProgram {
  name = "udisks2";
  system-nixos.services.udisks2.enable = true;
}
