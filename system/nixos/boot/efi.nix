{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.flags.efi {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
