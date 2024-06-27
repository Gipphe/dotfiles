{ lib, ... }:
{
  options.gipphe.boot.systemd-boot.enable = lib.mkEnableOption "systemd-boot";
}
