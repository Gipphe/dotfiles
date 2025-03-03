{ util, pkgs, ... }:
util.mkProgram {
  name = "signal";
  hm = {
    home.packages = [ pkgs.signal-desktop ];
    gipphe.windows.profiles.titanium.chocolatey.programs = [ "signal" ];
  };
}
