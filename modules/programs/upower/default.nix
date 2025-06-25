{ util, ... }:
util.mkProgram {
  name = "upower";
  system-nixos.services.upower.enable = true;
}
