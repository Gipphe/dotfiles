{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.system.udisks2.enable {
    services.udisks2.enable = true;
    services.dbus.packages = with pkgs; [ udisks2 ];
  };
}
