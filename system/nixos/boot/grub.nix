{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.flags.grub {
    # Bootloader.
    boot.loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
    };
  };
}
