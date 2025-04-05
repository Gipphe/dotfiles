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
  linux = lib.mkIf pkgs.stdenv.hostPlatform.isLinux { home.packages = [ linuxPackage ]; };
in
util.mkProgram {
  name = "filen";
  hm.config = lib.mkMerge [
    linux
  ];
  system-darwin.homebrew.casks = [ "filen" ];
}
