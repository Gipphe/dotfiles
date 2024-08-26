{ pkgs, util, ... }:
util.mkToggledModule [ "system" ] {
  name = "dbus";
  system-nixos.services.dbus = {
    enable = true;
    packages = with pkgs; [
      dconf
      udisks2
      gcr
    ];
  };
}
