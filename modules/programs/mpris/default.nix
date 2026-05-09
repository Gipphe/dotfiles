{ util, pkgs, ... }:
util.mkProgram {
  name = "mpris";
  home-manager = {
    home.packages = [ pkgs.playerctl ];
    services = {
      mpris-proxy.enable = true;
      playerctld.enable = true;
    };
  };
}
