{ util, ... }:
util.mkProgram {
  name = "upower";
  nixos.services.upower.enable = true;
}
