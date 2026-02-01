{ util, ... }:
util.mkProgram {
  name = "qt";
  hm = {
    qt = {
      enable = true;
      style = {
        name = "breeze";
      };
    };
    stylix.targets.qt = {
      platform = "gtk";
      standardDialogs = "xdgdesktopportal";
    };
  };
  system-nixos = {
    stylix.targets.qt.platform = "gtk";
  };
}
