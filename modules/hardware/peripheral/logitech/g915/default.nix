{ util, ... }:
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "g915";
  system-nixos = {
    services.hardware.openrgb = {
      enable = true;
    };
  };
}
