{ util, pkgs, ... }:
util.mkProgram {
  name = "mpris";
  hm = {
    services.mpris-proxy.enable = true;
  };
}
