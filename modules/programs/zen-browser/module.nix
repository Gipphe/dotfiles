{
  util,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  linuxAppImage = lib.fetchurl {
    src = "https://github.com/zen-browser/desktop/releases/latest/download/zen-specific.AppImage";
    hash = "";
  };
  linuxPkg = pkgs.appimageTools.wrapType2 {
    name = "ZenBrowser";
    src = linuxAppImage;
  };
  darwinPkg = inputs.brew-nix.packages.${pkgs.system}.zen-browser;
  pkg = if pkgs.stdenv.isDarwin then darwinPkg else linuxPkg;
in
util.mkProgram {
  name = "zen-browser";
  hm = lib.mkMerge [
    {
      programs.zen-browser = {
        enable = true;
        package = pkg;
        profiles = {
          default = {
            settings = {
              "browser.urlbar.trimHttps" = false;
              "browser.urlbar.trimUrls" = false;
              "taskbar.grouping.useprofile" = true;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            };
          };
        };
      };
      gipphe.windows.home.file = {
        "AppData/Roaming/zen/installs.ini".source = ./windows/installs.ini;
        "AppData/Roaming/zen/profiles.ini".source = ./windows/profiles.ini;
      };
    }

    (lib.mkIf pkgs.stdenv.isDarwin {
      home.file = {
        "Library/Application Support/zen/profiles.ini".source = ./darwin/profiles.ini;
        "Library/Application Support/zen/installs.ini".source = ./darwin/installs.ini;
      };
    })
  ];
}
