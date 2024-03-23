{
  pkgs,
  lib,
  config,
  system,
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

  cfg = config.filen;
in
{
  options = {
    filen = {
      enable = lib.mkEnableOption { name = "filen"; };
    };
  };
  config = lib.mkIf cfg.enable { home.packages = [ package ]; };
}
