{
  util,
  pkgs,
  flags,
  lib,
  ...
}:
util.mkProgram {
  name = "mpris";
  hm = lib.optionalAttrs (!flags.isNixDarwin) {
    home.packages = [ pkgs.playerctl ];
    services = {
      mpris-proxy.enable = true;
      playerctld.enable = true;
    };
  };
}
