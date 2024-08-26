{ util, pkgs, ... }:
util.mkToggledModule [ "system" ] {
  name = "udisks2";
  system-nixos = {
    services.udisks2.enable = true;
    services.dbus.packages = with pkgs; [ udisks2 ];
  };
}
