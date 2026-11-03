{ util, pkgs, ... }:
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "g502x";
  shared.gipphe.programs.openmouse-bridge.enable = true;
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
  };
}
