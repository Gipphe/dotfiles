{ util, pkgs, ... }:
util.mkProgram {
  name = "mpris";
  hm = {
    home.packages = [ pkgs.playerctl ];
    services = {
      mpris-proxy.enable = true;
      playerctld.enable = true;
    };
  };
}
