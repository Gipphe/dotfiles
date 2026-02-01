{ util, pkgs, ... }:
util.mkProgram {
  name = "gtk";
  hm = {
    gtk = {
      enable = true;
      colorScheme = "dark";
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
  };
}
