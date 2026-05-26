{ util, pkgs, ... }:
util.mkGaming {
  name = "prismlauncher";
  home-manager.home.packages = [ pkgs.prismlauncher ];
}
