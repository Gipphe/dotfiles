{ util, pkgs, ... }:
util.mkProgram {
  name = "thunar";
  system-nixos = {
    programs = {
      thunar = {
        enable = true;
        plugins = [
          pkgs.thunar-archive-plugin
          pkgs.thunar-vcs-plugin
          pkgs.thunar-volman
          pkgs.thunar-shares-plugin
          pkgs.thunar-media-tags-plugin
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
