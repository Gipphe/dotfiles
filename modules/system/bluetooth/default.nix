{
  util,
  pkgs,
  lib,
  ...
}:
util.mkToggledModule [ "system" ] {
  name = "bluetooth";
  options.gipphe.system.bluetooth.blueman.package = lib.mkPackageOption pkgs "blueman" { };
  hm.services.blueman-applet.enable = true;
  system-nixos = {
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      package = pkgs.bluez5-experimental;
    };
  };
}
