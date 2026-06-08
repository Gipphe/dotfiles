{
  lib,
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "gtk";
  homeManager = {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      gtk4.theme = lib.mkForce null;
    };
  };
}
