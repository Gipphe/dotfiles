{ pkgs, util, ... }:
util.mkToggledModule [ "system" ] {
  name = "dbus";
  system-nixos.services.dbus = {
    enable = true;
    packages = builtins.attrValues { inherit (pkgs) dconf udisks2 gcr; };
  };
}
