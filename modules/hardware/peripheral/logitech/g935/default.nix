{ util, pkgs, ... }:
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "g935";
  nixos = {
    environment.systemPackages = [ pkgs.headsetcontrol ];
    services = {
      hardware.openrgb.enable = true;
      udev = {
        enable = true;
        packages = [ pkgs.headsetcontrol ];
      };
    };
  };
}
