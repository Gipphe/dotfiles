{
  flags,
  inputs,
  pkgs,
  config,
  util,
  lib,
  ...
}:
let
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    image = lib.mkDefault config.environment.wallpaper.small-memory.image;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.source-sans;
        name = "Source Sans 3";
      };
      serif = {
        package = pkgs.source-serif;
        name = "Source Serif 4";
      };
    };

    polarity = "dark";

    # See https://github.com/nix-community/stylix/issues/1832
    overlays.enable = false;
  };
in
util.mkEnvironment {
  name = "stylix";

  homeManager = {
    imports = lib.optional flags.isNixOnDroid inputs.stylix.homeModules.stylix;
    config = lib.mkMerge [
      (lib.optionalAttrs flags.isNixOnDroid {
        inherit stylix;
      })
      {
        # TODO: Remove this redundant enabling when stylix catches up.
        home.pointerCursor.enable = true;
      }
    ];
  };
  nixos = {
    imports = [ inputs.stylix.nixosModules.stylix ];
    stylix = lib.mkMerge [
      stylix
      {
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 24;
        };
      }
    ];
    systemd.services."home-manager-${config.gipphe.username}".wants = [ "dbus.service" ];
  };

  nixOnDroid = {
    imports = [ inputs.stylix.nixOnDroidModules.stylix ];
    config = {
      inherit stylix;
    };
  };
}
