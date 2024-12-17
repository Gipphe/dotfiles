{
  pkgs,
  lib,
  util,
  ...
}:
let
  appImages = {
    "x86_64-linux" = {
      url = "https://github.com/FilenCloudDienste/filen-desktop/releases/download/v3.0.41/Filen_linux_x86_64.AppImage";
      hash = "0xcypk8h8w8k89y1q988xlcc0cq2vyjgilnwa5gwvzsm7xsjgyg6";
    };
    "aarch64-linux" = {
      url = "https://github.com/FilenCloudDienste/filen-desktop/releases/download/v3.0.41/Filen_linux_arm64.AppImage";
      hash = "0xcypk8h8w8k89y1q988xlcc0cq2vyjgilnwa5gwvzsm7xsjgyg6";
    };
  };
  linuxPackage = pkgs.appimageTools.wrapType2 {
    name = "filen";
    src = pkgs.fetchurl {
      url = appImages.${pkgs.system}.url;
      hash = appImages.${pkgs.system}.hash;
    };
  };
  linux = lib.mkIf pkgs.stdenv.isLinux { home.packages = [ linuxPackage ]; };
  darwinUnwrapped = pkgs.fetchzip {
    name = "filen-unwrapped";
    version = "3.0.41";
    url = "https://github.com/FilenCloudDienste/filen-desktop/releases/download/v3.0.41/Filen_mac_arm64.zip";
    hash = "sha256-ZHeZ26TXFS7dwiF0ITuMNWPOSk2xfw2r7DWeAICgEow=";
  };
  darwinPackage = pkgs.runCommandNoCC "filen" { version = "3.0.41"; } ''
    mkdir -p $out/Applications
    ln -s "${darwinUnwrapped}/Filen.app" "$out/Applications/Filen.app"
  '';
  darwin = lib.mkIf pkgs.stdenv.isDarwin { home.packages = [ darwinPackage ]; };
in
util.mkProgram {
  name = "filen";
  hm.config = lib.mkMerge [
    linux
    darwin
  ];
}
