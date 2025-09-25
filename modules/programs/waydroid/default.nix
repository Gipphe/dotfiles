{ util, ... }:
util.mkProgram {
  name = "waydroid";
  system-nixos.virtualisation.waydroid = {
    enable = true;
  };
}
