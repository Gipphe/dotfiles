{
  lib,
  config,
  pkgs,
  ...
}:
{
  config.stylix = lib.mkIf config.gipphe.environment.rice.enable {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    image = lib.mkDefault ../wallpaper/small-memory-wallpaper/wallpaper/wall.png;

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
  };
}
