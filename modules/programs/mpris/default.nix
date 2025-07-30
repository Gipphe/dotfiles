{ util, pkgs, ... }:
util.mkProgram {
  name = "mpris";
  hm = {
    hm.home.packages = [ pkgs.playerctl ];
    services.mpris-proxy.enable = true;
  };
}
