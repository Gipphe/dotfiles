{ util, ... }:
util.mkProgram {
  name = "automatic-timezoned";
  system-nixos.services.automatic-timezoned.enable = true;
}
