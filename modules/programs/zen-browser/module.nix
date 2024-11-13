{
  util,
  pkgs,
  lib,
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
  darwinPkg = pkgs.writeShellApplication {
    name = "dummy-zen-browser";
    text = ''
      open -na "Zen Browser.app"
    '';
  };
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
            search = {
              default = "Google";
              engines = {
                "nixpkgs" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "type";
                          value = "packages";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "!nix" ];
                };
                "NixOS options" = {
                  urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "!nixos" ];
                };
                "NixOS Wiki" = {
                  urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
                  iconUpdateURL = "https://wiki.nixos.org/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "!nw" ];
                };
                "GitHub" = {
                  urls = [ { template = "https://github.com/{searchTerms}"; } ];
                  definedAliases = [ "!gh" ];
                };
                "BoardGameGeek" = {
                  urls = [
                    {
                      template = "https://boardgamegeek.com/geeksearch.php?action=search&q={searchTerms}&objecttype=boardgame";
                    }
                  ];
                  definedAliases = [ "!bgg" ];
                };
                "Hoogle" = {
                  urls = [ { template = "https://hoogle.haskell.org/?hoogle={searchTerms}"; } ];
                  definedAliases = [ "!hoogle" ];
                };
                "npm" = {
                  urls = [ { template = "https://www.npmjs.com/search?q={searchTerms}"; } ];
                  definedAliases = [ "!npm" ];
                };
                "Wikipedia" = {
                  urls = [
                    {
                      template = "https://en.wikipedia.org/w/index.php?search={searchTerms}";
                    }
                  ];
                  definedAliases = [
                    "!w"
                    "w"
                  ];
                };
                "Google".metaData.alias = "g";
              };
              force = true;
              order = [
                "Google"
                "DuckDuckGo"
              ];
              privateDefault = "DuckDuckGo";
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
  system-darwin.homebrew.casks = [ "zen-browser" ];
}
