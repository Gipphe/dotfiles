{ util, pkgs, ... }:
util.mkProgram {
  name = "thunar";
  system-nixos.programs.thunar = {
    enable = true;
    plugins = [
      pkgs.xfce.thunar-archive-plugin
      pkgs.xfce.thunar-vcs-plugin
    ];
  };
}
