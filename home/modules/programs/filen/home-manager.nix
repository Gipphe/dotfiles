{
  pkgs,
  lib,
  inputs,
  config,
  system,
  utils,
  ...
}:
let
  appImages = {
    "x86_64-linux" = "https://cdn.filen.io/desktop/release/filen_x86_64.AppImage";
    "aarch64-linux" = "https://cdn.filen.io/desktop/release/filen_arm64.AppImage";
  };
  linuxPackage = pkgs.lib.appimageTools.wrapType2 {
    name = "filen";
    src = builtins.fetchurl {
      url = appImages.${system};
      sha256 = pkgs.lib.fakeSha256;
    };
  };
  linux = lib.mkIf lib.isLinux { home.packages = [ linuxPackage ]; };
  darwin = (
    lib.mkIf lib.isDarwin {
      home.packages = [
        (utils.setCaskHash inputs.brew-nix.packages.${system}.filen
          "sha256-ewoPrA8HuYftz9tvp7OUgDqikKhPZ7WOVyWH83oADJQ="
        )
      ];
    }
  );
in
{
  config = lib.mkIf config.gipphe.programs.filen.enable (
    lib.mkMerge [
      linux
      darwin
    ]
  );
}
