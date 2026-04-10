{ util, pkgs, ... }:
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "g935";
  system-nixos = {
    environment.systemPackages = [ pkgs.headsetcontrol ];
    services.udev = {
      enable = true;
      packages = [ pkgs.headsetcontrol ];
    };
  };
}
