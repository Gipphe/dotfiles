{
  config,
  util,
  lib,
  pkgs,
  ...
}:
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "g502x";
  options.gipphe.hardware.peripheral.logitech.g502x = {
    id = lib.mkOption {
      type = lib.types.str;
      description = "ID of the device as reported by lsusb";
      example = "046d:c539";
    };
  };
  homeManager = {
    home.packages = [ pkgs.piper ];
  };
  nixos = {
    programs.solaar = {
      enable = true;
      userService.enable = true;
    };
    services = {
      ratbagd.enable = true;
      libinput.enable = true;
      hardware.openrgb.enable = true;
    };
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "reset-mouse-kernel-module" ''
        echo "Rebinding the logitech-djreceiver driver..." >&2
        echo "0003:046D:C539.0003" | sudo ${pkgs.coreutils}/bin/tee /sys/bus/hid/drivers/logitech-djreceiver/unbind
        sleep 0.5
        echo "0003:046D:C539.0003" | sudo ${pkgs.coreutils}/bin/tee /sys/bus/hid/drivers/logitech-djreceiver/bind
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
