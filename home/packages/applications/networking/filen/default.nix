{
  pkgs,
  flags,
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
  dmgs = {
    "x86_64-darwin" = "https://cdn.filen.io/desktop/release/filen_x64.dmg";
    "aarch64-darwin" = "https://cdn.filen.io/desktop/release/filen_arm64.dmg";
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
  package = if lib.isDarwin then mac else linux;
in
{
  options.gipphe.programs.filen.enable = lib.mkEnableOption "filen";
  config = lib.mkIf config.gipphe.programs.filen.enable (
    lib.mkMerge [
      (lib.mkIf flags.system.isNixos { home.packages = [ package ]; })
      (lib.mkIf flags.system.isNixDarwin {
        home.packages = [
          (utils.setCaskHash inputs.brew-nix.packages.${system}.filen
            "sha256-ewoPrA8HuYftz9tvp7OUgDqikKhPZ7WOVyWH83oADJQ="
          )
        ];
      })
    ]
  );
}
