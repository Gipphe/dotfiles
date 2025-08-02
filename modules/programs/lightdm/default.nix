{ util, ... }:
util.mkProgram {
  name = "lightdm";
  system-nixos.services.xserver.displayManager.lightdm.enable = true;
}
