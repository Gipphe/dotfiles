{ util, pkgs, ... }:
util.mkProgram {
  name = "prismlauncher";
  home-manager.home.packages = [ pkgs.prismlauncher ];
}
