{ util, pkgs, ... }:
util.mkGaming {
  name = "prismlauncher";
  homeManager.home.packages = [ pkgs.prismlauncher ];
}
