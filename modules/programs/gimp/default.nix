{ util, pkgs, ... }:
util.mkProgram {
  name = "gimp";

  hm.home.packages = [
    pkgs.gimp-with-plugins
  ];
}
