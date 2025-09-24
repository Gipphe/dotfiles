{ pkgs }:
{
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
}
