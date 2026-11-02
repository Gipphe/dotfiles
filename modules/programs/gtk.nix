{
  den.aspects.programs.gtk.homeManager =
    { lib, pkgs, ... }:
    {
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
