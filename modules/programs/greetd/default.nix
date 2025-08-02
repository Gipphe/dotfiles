{ util, pkgs, ... }:
util.mkProgram {
  name = "greetd";
  system-nixos.services.greetd = {
    enable = true;
    package = pkgs.greetd.wlgreet;
  };
}
