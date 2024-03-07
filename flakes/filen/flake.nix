{
  inputs = { flake-utils.url = "github:numtide/flake-utils"; };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        appImages = {
          "x86_64-linux" =
            "https://cdn.filen.io/desktop/release/filen_x86_64.AppImage";
          "aarch64-linux" =
            "https://cdn.filen.io/desktop/release/filen_arm64.AppImage";
        };
        dmgs = {
          "x86_64-darwin" =
            "https://cdn.filen.io/desktop/release/filen_x64.dmg";
          "aarch64-darwin" =
            "https://cdn.filen.io/desktop/release/filen_arm64.dmg";
        };
        linux = pkgs.lib.appimageTools.wrapType2 {
          name = "filen";
          src = builtins.fetchurl {
            url = appImages.${system};
            sha256 = pkgs.lib.fakeSha256;
          };
        };
        mac = pkgs.mkDerivation {
          name = "filen";
          src = builtins.fetchurl {
            url = dmgs.${system};
            sha256 = pkgs.lib.fakeSha256;
          };
        };
      in {
        packages = {
          default = if builtins.match "darwin" system then mac else linux;
          filen = self.packages.default;
        };
      });
}
