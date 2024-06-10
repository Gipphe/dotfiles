{ lib, flags, ... }:
{
  config = lib.mkIf flags.bootloader.isEfi {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
