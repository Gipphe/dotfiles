{

  outputs = { self, nixpkgs, ... }:
    let forSystemPkgs = builtins.flip builtins.mapAttrs nixpkgs.legacyPackages;
    in {
      packages = forSystemPkgs (system: pkgs: {
        homeConfigurations = {
          "gipphe@Jarle" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            # Specify your home configuration modules here, for example,
            # the path to your home.nix.
            modules = [ ./home ];

            # Optionally use extraSpecialArgs
            # to pass through arguments to home.nix
            extraSpecialArgs = { hostname = "Jarle"; };
          };
          "victor@VNB-MB-Pro" = home-manager.lib.homeManagerConfiguration {

            inherit pkgs;

            modules = [ ./home ];
            extraSpecialArgs = { hostname = "Victors-MBP.Strise"; };
          };
          "victor@VNB-MB-Pro.local" =
            self.packages.${system}.homeConfigurations."victor@VNB-MB-Pro";
          "victor@Victors-MBP.Strise" =
            self.packages.${system}.homeConfigurations."victor@VNB-MB-Pro";
          "victor@Victors-MBP.Strise.local" =
            self.packages.${system}.homeConfigurations."victor@VNB-MB-Pro";
        };

        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#simple
        darwinConfigurations = {
          "VNB-MB-Pro" = darwin.lib.darwinSystem {
            modules = [
              ./machines/strise-mb/configuration.nix
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.victor = import ./home;
                home-manager.extraSpecialArgs = { hostname = "strise-mb"; };
              }
            ];
          };
          "VNB-MB-Pro.local" =
            self.packages.${system}.darwinConfigurations."VNB-MB-Pro";
          "Victors-MBP.Strise" =
            self.packages.${system}.darwinConfigurations."VNB-MB-Pro";
          "Victors-MBP.Strise.local" =
            self.packages.${system}.darwinConfigurations."VNB-MB-Pro";
        };
        # Build nixos flake using:
        # $ nixos-rebuild build --flake .#simple
        nixosConfiguration = {
          "nixvm" = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./machines/home-nix-vm/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.gipphe = import ./home;
                home-manager.extraSpecialArgs = { hostname = "home-nix-vm"; };
              }
            ];
          };
        };
      });

      devShells = forSystemPkgs (system: pkgs: {
        default = pkgs.mkShell { buildInputs = with pkgs; [ nixfmt ]; };
      });
    };
}
