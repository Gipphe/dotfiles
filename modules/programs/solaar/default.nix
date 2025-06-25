{ util, pkgs, ... }:
util.mkProgram {
  name = "solaar";
  hm = {
    home.packages = [ pkgs.solaar ];
  };
  system-nixos.hardware.logitech.wireless = {
    enable = true;
  };
}
