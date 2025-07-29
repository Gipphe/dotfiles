{ util, pkgs, ... }:
util.mkToggledModule [ "environment" ] {
  name = "gtk";
  hm.gtk.iconTheme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };
}
