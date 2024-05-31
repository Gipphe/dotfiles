{ lib, flags, ... }:
{
  config = lib.mkIf (flags.bootloader == "efi") {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
