{
  inputs,
  lib,
  flags,
  pkgs,
  ...
}:
{
  imports = [
    (
      if flags.system.isNixos then
        inputs.stylix.nixosModules.stylix
      else
        inputs.stylix.darwinModules.stylix
    )
  ];

  # Stylix' darwin module does not correctly import opacity module, but the
  # kitty stylix module uses it regardless. Here we can just manually define
  # the option ourselves.
  options.stylix.opacity.terminal = lib.mkOption {
    description = "The opacity of the windows of terminals, this works across all terminals supported by stylix";
    type = lib.types.float;
    default = 1.0;
  };

  config.stylix =
    {
      enable = flags.stylix.enable;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      image = ../../theme/minimal_forest/Macchiato-hald8-wall.png;

      fonts = {
        monospace = {
          package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
          name = "FiraCode Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
      };
    }
    // (lib.optionalAttrs flags.stylix.cursor {
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };
    });
}
