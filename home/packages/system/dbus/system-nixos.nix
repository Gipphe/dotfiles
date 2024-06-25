{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.system.dbus.enable {

    services = {
      dbus = {
        packages = with pkgs; [
          dconf
          udisks2
          gcr
        ];
        enable = true;
      };
    };
  };
}
