{
  den.aspects.system.xdg = {
    homeManager =
      { pkgs, ... }:
      {
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
            # TODO: Do I need gtk portal?
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
            setSessionVariables = false;
          };
        };
      };
    nixos = {
      environment.pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];
    };
  };
}
