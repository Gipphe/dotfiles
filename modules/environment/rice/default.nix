{
  inputs,
  config,
  lib,
  osConfig,
  pkgs,
  util,
  ...
}:
util.mkModule {
  options.gipphe.environment.rice.enable = lib.mkEnableOption "rice";

  hm.stylix = {
    inherit (osConfig.stylix) base16Scheme;
  };

  system-all.stylix = lib.mkIf config.gipphe.environment.rice.enable {
    enable = true;
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

  system-darwin = {
    imports = [ inputs.stylix.darwinModules.stylix ];

    config = lib.mkIf config.gipphe.environment.rice.enable {

      # environment.etc."sudoers.d/yabai".text =
      #   let
      #     yabai = config.services.yabai.package;
      #     hash = builtins.hashFile "sha256" "${yabai}/bin/yabai";
      #   in
      #   ''
      #     ${username} ALL=(root) NOPASSWD: sha256:${hash} ${yabai} --load-sa
      #   '';
      system.defaults = {
        # ".GlobalPreferences"."com.apple.mouse.scaling" = 1;
        CustomUserPreferences = {
          "com.apple.dock"."workspaces-swoosh-animation-off" = true;
        };
      };
      services.yabai = {
        enable = true;
        enableScriptingAddition = true;
        config = {
          layout = "float";
          window_gap = 5;
          window_shadow = "float";
          window_opacity = "on";
          active_window_opacity = 1.0;
          normal_window_opacity = 1.0;
        };
        # extraConfig = ''
        #   yabai -m rule --add app="IntelliJ IDEA" manage=off
        #   yabai -m rule --add app="IntelliJ IDEA" title=".*\[(.*)\].*" manage=on
        # '';
      };

      services.skhd = {
        enable = true;
        skhdConfig = ''
          # float / unfloat window and center on screen
          cmd + alt - t : yabai -m window --toggle float; \
                          yabai -m window --grid 4:4:1:1:2:2

          alt - t : yabai -m window --toggle float; \
                    yabai -m window --grid 20:20:1:1:18:18

          # change layout
          ctrl + alt - z : yabai -m space --layout bsp
          ctrl + alt - x : yabai -m space --layout float
        '';
      };
    };
  };

  system-nixos = {
    imports = [ inputs.stylix.nixosModules.stylix ];
    config = lib.mkIf config.gipphe.environment.rice.enable {
      stylix.cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };
  };
}
