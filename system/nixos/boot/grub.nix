{ lib, flags, ... }:
{
  config = lib.mkIf flags.bootloader.isGrub {
    boot.loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
    };
  };
}
