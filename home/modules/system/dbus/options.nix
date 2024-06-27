{ lib, ... }:
{
  options.gipphe.system.dbus.enable = lib.mkEnableOption "dbus";
}
