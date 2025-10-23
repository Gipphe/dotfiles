{
  util,
  pkgs,
  lib,
  flags,
  ...
}:
util.mkProgram {
  name = "signal";
  hm = lib.optionalAttrs (!flags.isNixDarwin) {
    home.packages = [ pkgs.signal-desktop ];
    gipphe.windows.chocolatey.programs = [ "signal" ];
  };
}
