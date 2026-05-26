{ util, pkgs, ... }:
util.mkProgram {
  name = "rider";
  homeManager = {
    home.packages = [
      pkgs.jetbrains.rider
    ];
  };
}
