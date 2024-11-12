{ util, lib, ... }:
util.mkProgram {
  name = "zen-browser";
  options.gipphe.programs.zen-browser.profiles = lib.mkOption {
    description = "Profile";
    type =
      with lib.types;
      attrsOf (submodule {
        options = {
          theme = lib.mkOption {
            type = str;
            description = "Name of theme to use";
            default = "catppuccin";
          };
          settings = lib.mkOption {
            description = "Configuration settings";
            type = attrsOf (oneOf [
              str
              int
            ]);
            default = { };
          };
        };
      });
  };
  hm = {
    gipphe.programs.zen-browser = {
      profiles = {
        default = {
          settings = {
            "browser.urlbar.ctrlCanonizesURLs" = false;
            "taskbar.grouping.useprofile" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
        };
      };
    };
    gipphe.home.file = {
      "AppData/Roaming/zen/installs.ini".source = ./installs.ini;
      "AppData/Roaming/zen/profiles.ini".source = ./profiles.ini;
    };
  };
}
