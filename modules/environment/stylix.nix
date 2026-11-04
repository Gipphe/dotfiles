{ inputs, ... }:
let
  mkStylix = { pkgs }: {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

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
{
  den.aspects.environment.stylix = {
    nixos = { user }: { lib, pkgs, ... }: {
      imports = [ inputs.stylix.nixosModules.stylix ];
      stylix = lib.mkMerge [
        (mkStylix { inherit pkgs; })
        {
          cursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Ice";
            size = 24;
          };
        }
      ];
      systemd.services."home-manager-${user.userName}".wants = [ "dbus.service" ];
    };

    nixOnDroid = { pkgs, ... }: {
      imports = [ inputs.stylix.nixOnDroidModules.stylix ];
      config = {
        stylix = mkStylix { inherit pkgs; };
      };
    };
  };
}
