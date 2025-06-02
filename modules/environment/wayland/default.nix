{ util, ... }:
util.mkEnvironment {
  name = "wayland";
  system-nixos.services.displayManager.sddm.wayland.enable = true;
}
