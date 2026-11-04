{
  den.aspects.environment.gtk = {
    homeManager = { pkgs, ... }: {
      home.pointerCursor.gtk.enable = true;
      gtk = {
        enable = true;
        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
        theme = {
          package = pkgs.catppuccin-gtk.override {
            size = "standard";
            accents = [ "sapphire" ];
            variant = "macchiato";
          };
          name = "catppuccin-macchiato-sapphire-standard";
        };
        gtk4.theme = null;
      };
    };
  };
}
