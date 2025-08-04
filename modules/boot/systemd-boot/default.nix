{ util, ... }:
util.mkToggledModule [ "boot" ] {
  name = "systemd-boot";
  system-nixos.boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
    };
    efi.canTouchEfiVariables = true;
  };
}
