{
  util,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.system.devices;
in
util.mkToggledModule [ "system" ] {
  name = "devices";
  options.gipphe.system.devices.logitech.enable = lib.mkEnableOption "logitech unifying defices";
  system-nixos.hardware.logitech.wireless = cfg.logitech.enable;
}
