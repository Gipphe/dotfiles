{ util, lib, ... }:
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "g903";
  options.gipphe.hardware.peripheral.logitech.g903 = {
    id = lib.mkOption {
      type = lib.types.str;
      description = "ID of the device as reported by lsusb";
      example = "046d:c539";
    };
  };
  system-nixos = {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    # Wait longer before suspending USB devices (like mice)
    boot.kernelParams = [ "usbcore.autosuspend=120" ];
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Logitech G903 LS]
      MatchName=Logitech G903 LS
      AttrEventCode=-REL_WHEEL_HI_RES;
    '';
  };
}
