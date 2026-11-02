{ inputs, den, ... }:
{
  den.aspects.gaming.steam = {
    includes = [
      den.aspects.gaming.gamescope
      (den.batteries.unfree [
        "steam-unwrapped"
        "steam-with-millennium"
      ])
    ];
    homeManager = { pkgs, ... }: {
      wayland.windowManager.hyprland.settings.window_rule = [
        {
          match.title = "Friends List";
          match.class = "steam";
          float = true;
        }
        {
          match.initial_class = "steam_app_.+";
          fullscreen = true;
        }
      ];
      xdg.configFile."autostart/steam.desktop".source = "${
        pkgs.callPackage ./_autostart.nix { }
      }/share/applications/steam-autostart.desktop";
    };

    nixos =
      { pkgs, ... }:
      let
        pkg =
          inputs.nixpkgs-with-millennium.legacyPackages.${pkgs.stdenv.hostPlatform.system}.steamWithMillennium.override
            {
              inherit (pkgs) steam;
              extraArgs = "-system-composer";
            };
      in
      {
        environment.variables = {
          # Workaround for controller detection issues
          PROTON_PREFER_SDL = "1";
          # Enable per-game shader cache, similar to Steam's "Shader Pre-Caching".
          PROTON_LOCAL_SHADER_CACHE = "1";
          # Enable native Wayland support.
          PROTON_ENABLE_WAYLAND = "1";
          # Disable window manager decorations. # Fixes: Borderless fullscreen
          # issues, mouse clicking through windows
          PROTON_NO_WM_DECORATION = "1";
        };
        programs.steam = {
          enable = true;
          package = pkg;
          protontricks.enable = true;
          gamescopeSession.enable = true;
          extraCompatPackages = [
            pkgs.proton-ge-bin
          ];
        };
      };
  };
}
