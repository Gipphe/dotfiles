{ util, ... }:
util.mkProgram {
  name = "lightdm";
  nixos.services.xserver.displayManager.lightdm.enable = true;
}
