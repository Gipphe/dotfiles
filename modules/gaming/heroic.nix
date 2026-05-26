{ util, pkgs, ... }:
util.mkGaming {
  name = "heroic";
  homeManager = {
    home.packages = [ pkgs.heroic ];
  };
}
