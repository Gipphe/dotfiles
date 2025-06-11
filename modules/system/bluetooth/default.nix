{ util, pkgs, ... }:
util.mkToggledModule [ "system" ] {
  name = "bluetooth";
  system-nixos.hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    package = pkgs.bluez5-experimental;
  };
}
