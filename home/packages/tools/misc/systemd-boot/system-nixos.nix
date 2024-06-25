{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.boot.systemd-boot.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
