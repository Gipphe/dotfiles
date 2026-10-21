{ util, pkgs, ... }:
util.mkGaming {
  name = "limo";
  homeManager = {
    home.packages = [ pkgs.limo ];
  };
}
