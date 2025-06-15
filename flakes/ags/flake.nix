{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      ags,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # additional libraries and packages to add to gjs' runtime
      extraPackages = with ags.packages.${system}; [
        # ags.packages.${system}.battery
        # pkgs.fzf
        battery
        hyprland
        mpris
        network
        tray
        wireplumber
      ];
    in
    {
      homeManagerModules.${system}.default =
        {
          lib,
          config,
          pkgs,
          ...
        }:
        {
          options.programs.ags = {
            enable = lib.mkEnableOption "giphtbar (ags bar)";
          };
          config = lib.mkIf config.programs.ags.enable {
            home.packages = [
              pkgs.upower
              self.packages.${system}.default
            ];
          };
        };
      packages.${system}.default =
        ags.lib.bundle
          {
            inherit pkgs;
            src = ./.;
            name = "giphtshell";
            entry = "app.ts";
            gtk4 = false;
            inherit extraPackages;
          }
          .override
          (
            prevAttrs:
            prevAttrs
            // {
              checkPhase = ''
                ${prevAttrs.checkPhase}
                if command -v 'upower' &>/dev/null; then
                  
                fi
              '';
            }
          );
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          (ags.packages.${system}.default.override {
            inherit extraPackages;
          })
        ];
      };
    };
}
