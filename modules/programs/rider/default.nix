{ util, pkgs, ... }:
util.mkProgram {
  name = "rider";
  hm = {
    home.packages = [
      pkgs.jetbrains.rider
    ];
  };
}
