{ util, pkgs, ... }:
util.mkProgram {
  name = "greetd";
  nixos.services.greetd = {
    enable = true;
    package = pkgs.greetd.wlgreet;
  };
}
