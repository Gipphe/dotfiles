{ util, ... }:
util.mkProgram {
  name = "powertop";
  system-nixos.powerManagement.powertop.enable = true;
}
