{ util, ... }:
util.mkToggledModule [ "boot" ] {
  name = "systemd-boot";
  system-nixos.boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 30;
      memtest86.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };
}
