{
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "gtk";
  hm = {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      gtk4.theme = null;
    };
  };
}
