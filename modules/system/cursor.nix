{
  den.aspects.system.cursor = {
    homeManager = { pkgs, ... }: {
      home.pointerCursor = {
        enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };
    nixos.environment.variables.XCURSOR_SIZE = "24";
  };
}
