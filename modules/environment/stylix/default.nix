{
  inputs,
  pkgs,
  config,
  util,
  # osConfig,
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
  };
in
util.mkEnvironment {
  name = "stylix";

  hm = {
    # imports = [ inputs.stylix.homeManagerModules.stylix ];
    # stylix.enable = pkgs.system != "aarch64-linux";
    # stylix = {
    #   base16Scheme = lib.mkForce stylix.base16Scheme;
    # };
  };

  system-darwin = {
    imports = [ inputs.stylix.darwinModules.stylix ];
    inherit stylix;
  };

  system-nixos = {
    imports = [ inputs.stylix.nixosModules.stylix ];
    stylix = lib.mkMerge [
      stylix
      {
        cursor = {
          package = pkgs.vimix-cursors;
          name = "Vimix-white-cursors";
          size = 24;
        };
      }
    ];
    systemd.services."home-manager-${config.gipphe.username}".wants = [ "dbus.service" ];
  };
}
