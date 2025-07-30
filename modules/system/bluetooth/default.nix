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
      powerOnBoot = true;
      package = pkgs.bluez5-experimental;
      # Enable A2DP sinks
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
  };
}
