{ util, pkgs, ... }:
util.mkProgram {
  name = "prismlauncher";
  hm.home.packages = [ pkgs.prismlauncher ];
}
