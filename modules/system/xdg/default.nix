{ util, ... }:
util.mkSystem {
  name = "xdg";
  hm = {
    xdg = {
      enable = true;
      mimeApps.enable = true;
      portal.enable = true;
      portal.xdgOpenUsePortal = true;
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
