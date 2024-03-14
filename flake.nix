{
  description = "Home Manager configuration of gipphe";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, darwin, nixpkgs, home-manager, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.homeConfigurations = {
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
        packages.darwinConfigurations = {

          "VNB-MB-Pro" = darwin.lib.darwinSystem {
            modules = [ ../machines/strise-mb/configuration.nix ];
          };
          "VNB-MB-Pro.local" =
            self.packages.${system}.darwinConfigurations."VNB-MB-Pro";
          "Victors-MBP.Strise" =
            self.packages.${system}.darwinConfigurations."VNB-MB-Pro";
          "Victors-MBP.Strise.local" =
            self.packages.${system}.darwinConfigurations."VNB-MB-Pro";
        };

        # Expose the package set, including overlays, for convenience.
        darwinPackages = self.darwinConfigurations."VNB-MB-Pro".pkgs;

        devShells.default =
          pkgs.mkShell { buildInputs = with pkgs; [ nixfmt ]; };
      });
}
