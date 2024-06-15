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
