{
  util,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.floorp;
  pkg =
    if (pkgs.stdenv.isLinux && cfg.enable) then
      pkgs.floorp
    else
      pkgs.runCommandNoCC "dummy-ff" { } ''
        mkdir -p $out
        echo "foo" >> $out/bin/foo
      '';
in
util.mkModule {
  options.gipphe.programs.floorp = {
    enable = lib.mkEnableOption "floorp";
    windows = lib.mkOption {
      description = "Set up Floorp for Windows";
      type = lib.types.bool;
      default = true;
    };
  };
  hm = {
    config = lib.mkMerge [
      {
        programs.floorp = {
          enable = cfg.enable || cfg.windows;
          package = pkg;
          profiles = {
            default = {
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
              };
              settings = {
                "browser.urlbar.trimHttps" = false;
                "browser.urlbar.trimUrls" = false;
                "taskbar.grouping.useprofile" = true;
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              };
            };
          };
        };
        gipphe.windows = {
          environment.variables."MOZ_LEGACY_PROFILES" = "1";
          chocolatey.programs = [ "floorp" ];
        };
      }
      (lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
        home.packages = [
          (pkgs.writeShellScriptBin "floorp" ''
            MOZ_LEGACY_PROFILES=1 open -na "Floorp.app"
          '')
        ];
      })
    ];
  };
  system-darwin = lib.mkIf cfg.enable { homebrew.casks = [ "floorp" ]; };
}
