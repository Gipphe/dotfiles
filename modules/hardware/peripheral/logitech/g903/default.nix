{
  config,
  util,
  lib,
  pkgs,
  ...
}:
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "g903";
  options.gipphe.hardware.peripheral.logitech.g903 = {
    id = lib.mkOption {
      type = lib.types.str;
      description = "ID of the device as reported by lsusb";
      example = "046d:c539";
    };
  };
  home-manager = {
    home.packages = [ pkgs.piper ];
    wayland.windowManager.hyprland.settings.device = [
      {
        name = "logitech-g903-ls-1";
        scroll_method = "no_scroll";
      }
    ];
  };
  nixos = {
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
    services = {
      ratbagd.enable = true;
      libinput.enable = true;
      udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c539", ATTR{power/autosuspend}="-1"
      ''
      + lib.optionalString false ''
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c539", RUN+="${pkgs.systemd}/bin/systemd-run --no-block ${pkgs.writeShellScript "reload-logitech-hid" ''
          sleep 0.5
          modprobe -r hid_logitech_dj
          modprobe hid_logitech_dj
        ''}"
      '';
      hardware.openrgb.enable = true;
    };
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "reset-mouse-kernel-module" ''
        echo "Rebinding the logitech-djreceiver driver..." >&2
        echo "0003:046D:C539.0003" | sudo tee /sys/bus/hid/drivers/logitech-djreceiver/unbind
        sleep 0.5
        echo "0003:046D:C539.0003" | sudo tee /sys/bus/hid/drivers/logitech-djreceiver/bind
        echo "Rebound. Hoping the scrollwheel works now!" >&2
      '')
    ];
    security.sudo.extraRules = [
      {
        users = [ config.gipphe.username ];
        commands = [
          {
            command = "${pkgs.coreutils}/bin/tee /sys/bus/hid/drivers/logitech-djreceiver/unbind";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.coreutils}/bin/tee /sys/bus/hid/drivers/logitech-djreceiver/bind";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
