{
  util,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.floorp;
  windows = import ./windows.nix;
  pkg = if (pkgs.stdenv.hostPlatform.isLinux && cfg.enable) then pkgs.floorp else null;
in
util.mkModule {
  options.gipphe.programs.floorp = {
    enable = lib.mkEnableOption "floorp";
    windows = lib.mkOption {
      description = "Set up Floorp for Windows";
      type = lib.types.bool;
      default = true;
    };
    default = lib.mkEnableOption "Floorp as default browser";
    package = lib.mkPackageOption pkgs "floorp" { } // {
      default = config.programs.floorp.finalPackage;
    };
  };
  hm.config = lib.mkMerge [
    {
      gipphe.default.browser = lib.mkIf cfg.default {
        open = "${cfg.package}/bin/floorp";
      };
      stylix.targets.floorp.profileNames = [ "default" ];
      programs.floorp = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        enable = cfg.enable || cfg.windows;
        package = pkg;
        profiles = {
          default = {
            search = {
              default = "google";
              force = true;
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
                  icon = "https://wiki.nixos.org/favicon.png";
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
      };
      gipphe.windows = {
        # environment.variables."MOZ_LEGACY_PROFILES" = "1";
        chocolatey.programs = [ "floorp" ];
        # home.file =
        #   let
        #     fs = config.home.file;
        #     optionalFile =
        #       pathTo: pathFrom:
        #       if (builtins.hasAttr pathFrom fs) then
        #         {
        #           ${pathTo}.source = (builtins.getAttr pathFrom fs).source;
        #         }
        #       else
        #         { };
        #   in
        #   {
        #     "AppData/Roaming/Floorp/profiles.ini".source =
        #       pkgs.runCommandNoCC "floorp-profiles" { } # bash
        #         ''
        #           cat "${fs.".floorp/profiles.ini".source}" >> $out
        #           echo "" >> $out
        #           echo "${windows.backgroundTasksProfile}" >> $out
        #         '';
        #   }
        #   // optionalFile "AppData/Roaming/Floorp/Profiles/default/search.json.mozlz4" ".floorp/default/search.json.mozlz4"
        #   // optionalFile "AppData/Roaming/Floorp/Profiles/default/user.js" ".floorp/default/user.js"
        #   // optionalFile "AppData/Roaming/Floorp/Profiles/default/chrome/userContent.css" ".floorp/default/chrome/userContent.css"
        #   // optionalFile "AppData/Roaming/Floorp/Profiles/default/chrome/userChrome.css" ".floorp/default/chrome/userChrome.css";
      };
    }
    (lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isDarwin) {
      home.packages = [
        (pkgs.writeShellScriptBin "floorp" ''
          MOZ_LEGACY_PROFILES=1 open -na "Floorp.app"
        '')
      ];
    })
  ];
  system-darwin = lib.mkIf cfg.enable { homebrew.casks = [ "floorp" ]; };
}
