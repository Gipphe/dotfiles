{ util, pkgs, ... }:
util.mkProgram {
  name = "thunar";
  system-nixos = {
    programs = {
      thunar = {
        enable = true;
        plugins = [
          pkgs.xfce.thunar-archive-plugin
          pkgs.xfce.thunar-vcs-plugin
          pkgs.xfce.thunar-volman
          pkgs.xfce.thunar-shares-plugin
          pkgs.xfce.thunar-media-tags-plugin
        ];
      };
      # Without xfce, we need xfconf for thunar to save preferences.
      xfconf.enable = true;
    };
    services = {
      # Provides trash, mount points, etc. to thunar.
      gvfs.enable = true;
    };
  };
}
