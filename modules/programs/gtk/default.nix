{ util, pkgs, ... }:
util.mkProgram {
  name = "gtk";
  hm.gtk.iconTheme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };
}
