{ util, pkgs, ... }:
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "a50gen5";
  nixos = {
    programs.solaar = {
      enable = true;
      userService.enable = true;
    };
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
