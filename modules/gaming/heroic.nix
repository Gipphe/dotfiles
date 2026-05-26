{ util, pkgs, ... }:
util.mkGaming {
  name = "heroic";
  home-manager = {
    home.packages = [ pkgs.heroic ];
  };
}
