{ util, pkgs, ... }:
util.mkModule {
  hm = {
    programs.floorp.profiles.default = {
      search = {
        default = "startpage";
        force = true;
        engines = {
          "nixpkgs" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
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
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "!nixos" ];
          };
          "NixOS Wiki" = {
            urls = [
              {
                template = "https://wiki.nixos.org/index.php";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "https://wiki.nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "!nw" ];
          };
          "Home Manager Options" = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com/";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "release";
                    value = "master";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "!hm" ];
          };
          "GitHub" = {
            urls = [ { template = "https://github.com/{searchTerms}"; } ];
            definedAliases = [ "!gh" ];
          };
          "GitHub search" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "!ghs" ];
          };
          "BoardGameGeek" = {
            urls = [
              {
                template = "https://boardgamegeek.com/geeksearch.php";
                params = [
                  {
                    name = "action";
                    value = "search";
                  }
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                  {
                    name = "objecttype";
                    value = "boardgame";
                  }
                ];
              }
            ];
            definedAliases = [ "!bgg" ];
          };
          "Hoogle" = {
            urls = [
              {
                template = "https://hoogle.haskell.org/";
                params = [
                  {
                    name = "hoogle";
                    value = "{searchTerms}";
                  }

                ];
              }
            ];
            definedAliases = [ "!hoogle" ];
          };
          "npm" = {
            urls = [
              {
                template = "https://www.npmjs.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "!npm" ];
          };
          "Wikipedia" = {
            urls = [
              {
                template = "https://en.wikipedia.org/w/index.php";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [
              "!w"
              "w"
            ];
          };
          "google".metaData.alias = "g";
        };
      };
      settings = {
        "browser.urlbar.trimHttps" = false;
        "browser.urlbar.trimUrls" = false;
        "taskbar.grouping.useprofile" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # Disable kinetic/momentum/inertia when scrolling (especially bad
        # with touchpad)
        "apz.gtk.kinetic_scroll.enabled" = false;
      };
    };
  };
}
