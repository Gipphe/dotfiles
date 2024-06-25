{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.system.udisks2.enable {
    services.udisks2.enable = true;
    dbus = lib.mkIf config.gipphe.system.dbus.enable { packages = with pkgs; [ udisks2 ]; };
  };
}
