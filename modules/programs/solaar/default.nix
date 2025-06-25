{ util, pkgs, ... }:
util.mkProgram {
  name = "solaar";
  hm = {
    home.packages = with pkgs; [
      solaar
      logitech-udev-rules
    ];
  };
}
