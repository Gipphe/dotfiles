let
  size = "standard";
in
{
  den.aspects.environment.gtk = {
    homeManager = { pkgs, config, ... }: {
      home.pointerCursor.gtk.enable = true;
      gtk = {
        enable = true;
        theme = {
          package = pkgs.catppuccin-gtk.override {
            inherit size;
            accents = [ config.catppuccin.accent ];
            variant = config.catppuccin.flavor;
          };
          name = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}-${size}";
        };
        gtk4.theme = null;
      };
    };
  };
}
