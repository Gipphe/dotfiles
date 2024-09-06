{ util, ... }:
util.mkToggledModule [ "boot" ] {
  name = "grub";

  system-nixos.boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };
}
