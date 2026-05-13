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
        echo "Restarting the hid_logitech_dj kernel module..." >&2
        sudo ${pkgs.kmod}/bin/modprobe -r hid_logitech_dj
        sudo ${pkgs.kmod}/bin/modprobe hid_logitech_dj
        echo "Restarted. Hoping the scrollwheel works now!" >&2
      '')

      # `hyprctl devices` output when it works:
      #
      # mice:
      #         Mouse at 56634e532790:
      #                 logitech-usb-receiver
      #                         default speed: 0.00000
      #                         scroll factor: -1.00
      #         Mouse at 56634e579140:
      #                 logitech-usb-receiver-keyboard-1
      #                         default speed: 0.00000
      #                         scroll factor: -1.00
      #         Mouse at 56634eb8e260:
      #                 logitech-g903-ls-1
      #                         default speed: 0.00000
      #                         scroll factor: -1.00
      (pkgs.writeShellScriptBin "debug-mouse-scroll" ''
        sudo ${pkgs.libinput}/bin/libinput debug-events | ${pkgs.gnugrep}/bin/grep POINTER_SCROLL
      '')
    ];
    security.sudo.extraRules = [
      {
        users = [ config.gipphe.username ];
        commands = [
          {
            command = "${pkgs.kmod}/bin/modprobe -r hid_logitech_dj";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.kmod}/bin/modprobe hid_logitech_dj";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
