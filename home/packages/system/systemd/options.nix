{ lib, ... }:
{
  options.gipphe.system.systemd.enable = lib.mkEnableOption "systemd";
}
