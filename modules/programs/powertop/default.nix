{ util, ... }:
util.mkProgram {
  name = "powertop";
  nixos.powerManagement.powertop.enable = true;
}
