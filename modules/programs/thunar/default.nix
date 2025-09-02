{ util, pkgs, ... }:
util.mkProgram {
  name = "thunar";
  system-nixos.programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-vcs-plugin
    ];
  };
}
