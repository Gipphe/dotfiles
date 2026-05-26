{ util, pkgs, ... }:
util.mkProgram {
  name = "mpris";
  homeManager = {
    home.packages = [ pkgs.playerctl ];
    services = {
      mpris-proxy.enable = true;
      playerctld.enable = true;
    };
  };
}
