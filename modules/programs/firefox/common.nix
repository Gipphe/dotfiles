{ pkgs, ... }:
{
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
        definedAliases = [ "@np" ];
      };
      "NixOS Wiki" = {
        urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
        iconUpdateURL = "https://wiki.nixos.org/favicon.png";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = [ "@nw" ];
      };
      "Bing".metaData.hidden = true;
      "eBay".metaData.hidden = true;
      "Google".metaData.alias = "@g";
    };
    force = true;
    order = [
      "Google"
      "DuckDuckGo"
    ];
    privateDefault = "DuckDuckGo";
  };

  settings = {
    "browser.aboutConfig.showWarning" = false;
    "browser.aboutwelcome.didSeeFinalScreen" = true;
    "browser.bookmarks.restore_default_bookmarks" = false;
    "browser.bookmarks.showMobileBookmarks" = true;
    "browser.contentblocking.category" = "standard";
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = true;
    "browser.engagement.ctrlTab.has-used" = true;
    "browser.engagement.fxa-toolbar-menu-button.has-used" = true;
    "browser.search.newSearchConfig.enabled" = true;
    "browser.search.region" = "NO";
    "browser.urlbar.ctrlCanonizesURLs" = false;
    "devtools.everOpened" = true;
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_ever_enabled" = true;
    "network.dns.disablePrefetch" = true;
    "network.predictor.enabled" = false;
    "network.prefetch-next" = false;
    "network.trr.mode" = 2;
    "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
    "privacy.bounceTrackingProtection.hasMigratedUserActivationData" = true;
    "privacy.donottrackheader.enabled" = true;
    "privacy.exposeContentTitleInWindow" = false;
    "privacy.exposeContentTitleInWindow.pbm" = false;
    "privacy.globalprivacycontrol.enabled" = true;
    "privacy.globalprivacycontrol.was_ever_enabled" = true;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };
  userChrome = # css
    ''
      /* Hide top tab bar */
      #TabsToolbar {
        visibility: collapse;
      }
    '';

  bangs = {
    name = "Bangs";
    bookmarks = [
      {
        name = "Github";
        tags = [ "bang" ];
        keyword = "!gh";
        url = "https://github.com/%s";
      }
      {
        name = "BoardGameGeek";
        tags = [ "bang" ];
        keyword = "!bgg";
        url = "https://boardgamegeek.com/geeksearch.php?action=search&q=%s&objecttype=boardgame";
      }
      {
        name = "NixOS Search";
        tags = [ "bang" ];
        keyword = "!nixos";
        url = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=%s";
      }
      {
        name = "Kagi";
        tags = [ "bang" ];
        keyword = "!k";
        url = "https://kagi.com/search?q=%s";
      }
      {
        name = "hoogle";
        tags = [ "bang" ];
        keyword = "!hoogle";
        url = "https://hoogle.haskell.org/?hoogle=%s";
      }
      {
        name = "Wikipedia";
        tags = [ "bang" ];
        keyword = "!w";
        url = "https://no.wikipedia.org/wiki/Special:Search?search=%s";
      }
      {
        name = "npm";
        tags = [ "bang" ];
        keyword = "!npm";
        url = "https://www.npmjs.com/search?q=%s";
      }
      {
        name = "nixpkgs search";
        tags = [ "bang" ];
        keyword = "!nix";
        url = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=%s";
      }
    ];
  };
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  platforms = {
    linux = rec {
      profilesSubdir = "";
      vendorPath = ".mozilla";
      configPath = "${vendorPath}/firefox";
      profilesPath = configPath;
    };
    darwin = rec {
      profilesSubdir = "Profiles";
      vendorPath = "Library/Application Support/Mozilla";
      configPath = "Library/Application Support/Firefox";
      profilesPath = "${configPath}/${profilesSubdir}";
    };
    windows = rec {
      profilesSubdir = "Profiles";
      vendorPath = "AppData/Roaming/Mozilla";
      configPath = "${vendorPath}/Firefox";
      profilesPath = "${configPath}/${profilesSubdir}";
    };
  };

  installHashes = {
    firefox = "308046B0AF4A39CB";
    firefox-devedition = "CA9422711AE1A81C";
  };
}
