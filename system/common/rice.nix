{
  inputs,
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
  stylix = {
    enable = flags.aux.stylix;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    image = ../../theme/minimal_forest/Macchiato-hald8-wall.png;

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
        name = "Fira Code Nerd Font Mono";
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
  };
}
