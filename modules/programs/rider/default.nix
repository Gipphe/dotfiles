{ util, pkgs, ... }:
util.mkProgram {
  name = "rider";
  home-manager = {
    home.packages = [
      pkgs.jetbrains.rider
    ];
  };
}
