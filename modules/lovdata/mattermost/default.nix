{
  inputs,
  util,
  pkgs,
  lib,
  config,
  ...
}:
let
  pkg = pkgs.mattermost-desktop;
in
util.mkToggledModule [ "lovdata" ] {
  name = "mattermost";
  hm = {
    imports = [ inputs.lovdata.homeModules.mattermost ];
    config = {
      lovdata.mattermost = {
        enable = true;
        settings = {
          showTrayIcon = true;
          notifications = {
            flashWindow = 0;
            bounceIcon = true;
            bounceIconType = "informational";
          };
          showUnreadBadge = true;
          useSpellChecker = true;
          enableHardwareAcceleration = true;
          autostart = false;
          hideOnStart = false;
          spellCheckerLocales = [
            "en-GB"
            "nb"
          ];
          darkMode = false;
          lastActiveTeam = 0;
          downloadLocation = "${config.home.homeDirectory}/Downloads";
          startInFullscreen = false;
          lovLevel = "info";
          enableMetrics = false;
          trayIconTheme = "use_system";
          alwaysMinimize = true;
        };
      };
      gipphe.core.wm.binds = [
        {
          mod = "$mod";
          key = "M";
          action.spawn = "${lib.getExe pkg}";
        }
      ];
    };
  };
}
