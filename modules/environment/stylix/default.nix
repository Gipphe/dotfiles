{
  inputs,
  pkgs,
  config,
  util,
  osConfig,
  lib,
  ...
}:
util.mkEnvironment {
  name = "stylix";

  hm.stylix = {
    inherit (osConfig.stylix) base16Scheme;
  };

  system-all.stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    image = lib.mkDefault config.environment.wallpaper.small-memory.image;

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

  system-darwin.imports = [ inputs.stylix.darwinModules.stylix ];

  system-nixos = {
    imports = [ inputs.stylix.nixosModules.stylix ];
    stylix.cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };
}
