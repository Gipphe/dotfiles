{ util, pkgs, ... }:
util.mkSystem {
  name = "xdg";
  hm = {
    xdg = {
      enable = true;
      mimeApps.enable = true;
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config = {
          common = {
            default = [ "gtk" ];
          };
        };
        extraPortals = builtins.attrValues {
          inherit (pkgs)
            xdg-desktop-portal
            xdg-desktop-portal-gtk
            ;
        };
      };
      terminal-exec.enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
  };
  system-nixos = {
    environment.pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
  };
}
