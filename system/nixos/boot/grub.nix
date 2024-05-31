{ lib, flags, ... }:
{
  config = lib.mkIf (flags.bootloader == "grub") {
    # Bootloader.
    boot.loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
    };
  };
}
