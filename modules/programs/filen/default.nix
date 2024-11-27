{
  pkgs,
  lib,
  inputs,
  util,
  ...
}:
let
  appImages = {
    "x86_64-linux" = "https://cdn.filen.io/desktop/release/filen_x86_64.AppImage";
    "aarch64-linux" = "https://cdn.filen.io/desktop/release/filen_arm64.AppImage";
  };
  linuxPackage = pkgs.appimageTools.wrapType2 {
    name = "filen";
    src = builtins.fetchurl {
      url = appImages.${pkgs.system};
      sha256 = "0xcypk8h8w8k89y1q988xlcc0cq2vyjgilnwa5gwvzsm7xsjgyg6";
    };
  };
  linux = lib.mkIf pkgs.stdenv.isLinux { home.packages = [ linuxPackage ]; };
  darwin = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [
      (util.setCaskHash inputs.brew-nix.packages.${pkgs.system}.filen
        "sha256-95nv9+eja+Al2nknKIVr9a3smlL2PMEOb9tghfRBs1I="
      )
    ];
  };
in
util.mkProgram {
  name = "filen";
  hm.config = lib.mkMerge [
    linux
    darwin
  ];
}
