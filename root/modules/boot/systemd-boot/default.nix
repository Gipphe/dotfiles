{ util, ... }:
util.mkToggledModule [ "boot" ] {
  name = "systemd-boot";
  system-nixos.boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
