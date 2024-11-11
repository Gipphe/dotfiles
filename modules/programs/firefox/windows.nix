{
  config,
  pkgs,
  lib,
  util,
  ...
}:
let
  inherit (lib)
    concatMap
    flip
    generators
    hasAttr
    hasPrefix
    listToAttrs
    mapAttrs
    mapAttrs'
    mapAttrsToList
    mkMerge
    nameValuePair
    optional
    pipe
    ;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (import ./common.nix { inherit pkgs; })
    installHashes
    platforms
    ;
  cfg = config.gipphe.programs.firefox;
  thisPlatform = if pkgs.stdenv.hostPlatform.isDarwin then platforms.darwin else platforms.linux;
  windowsPlatform = platforms.windows;
  progCfg = config.programs.firefox;

  installToINIAttrs = install: {
    Default = "${windowsPlatform.profilesSubdir}/${progCfg.profiles.${install.defaultProfile}.path}";
    Locked = if install.locked then 1 else 0;
  };
  profiles =
    flip mapAttrs' progCfg.profiles (
      _: profile:
      nameValuePair "Profile${toString profile.id}" {
        Name = profile.name;
        Path = if isDarwin then "Profiles/${profile.path}" else profile.path;
        IsRelative = 1;
        Default = if profile.isDefault then 1 else 0;
      }
    )
    // {
      General =
        {
          StartWithLastProfile = 1;
        }
        // lib.optionalAttrs (progCfg.profileVersion != null) {
          Version = progCfg.profileVersion;
        };

      # These were there to begin with. Not sure what they are.
      BackgroundTasksProfiles = {
        MozillaBackgroundTask-CA9422711AE1A81C-defaultagent = "sxas54oh.MozillaBackgroundTask-CA9422711AE1A81C-defaultagent";
        MozillaBackgroundTask-CA9422711AE1A81C-backgroundupdate = "bfl2vmny.MozillaBackgroundTask-CA9422711AE1A81C-backgroundupdate";
        MozillaBackgroundTask-308046B0AF4A39CB-defaultagent = "mnlu1hsw.MozillaBackgroundTask-308046B0AF4A39CB-defaultagent";
        MozillaBackgroundTask-308046B0AF4A39CB-backgroundupdate = "zi5fjf94.MozillaBackgroundTask-308046B0AF4A39CB-backgroundupdate";
      };
    }
    // flip mapAttrs' cfg.installs (
      id: install: nameValuePair "Install${id}" (installToINIAttrs install)
    );
in
util.mkModule {
  hm.gipphe = lib.mkIf (pkgs.stdenv.isLinux && config.gipphe.programs.firefox.enable) {
    programs.firefox.installs = {
      ${installHashes.windows.firefox}.defaultProfile = "default";
      ${installHashes.windows.firefox-devedition}.defaultProfile = "strise";
    };
    windows.home.file = mkMerge (
      optional (cfg.installs != { }) {
        "${windowsPlatform.configPath}/installs.ini".text = generators.toINI { } (
          mapAttrs (_: i: installToINIAttrs i) cfg.installs
        );
      }
      ++ optional (hasAttr "${thisPlatform.configPath}/profiles.ini" config.home.file) {
        "${windowsPlatform.configPath}/profiles.ini".text = generators.toINI { } (
          flip mapAttrs profiles (
            name: val:
            if hasPrefix "Profile" name then
              val // { Path = "${windowsPlatform.profilesSubdir}/${val.Path}"; }
            else
              val
          )
        );
      }
      ++ flip mapAttrsToList progCfg.profiles (
        _: profile:
        let
          copyProfileFile =
            f:
            let
              profileFilePath = "${profile.path}/${f}";
              sourcePath = "${thisPlatform.profilesPath}/${profileFilePath}";
              destPath = "${windowsPlatform.profilesPath}/${profileFilePath}";
            in
            optional (hasAttr sourcePath config.home.file) (
              nameValuePair destPath {
                inherit (config.home.file.${sourcePath}) source;
              }
            );
          profileFiles = [
            ".keep"
            "chrome/userChrome.css"
            "chrome/userContent.css"
            "user.js"
            "containers.json"
            "search.json.mozlz4"
          ];
        in
        # TODO: deal with extensions directory
        pipe profileFiles [
          (concatMap copyProfileFile)
          listToAttrs
        ]
      )
    );
  };
}
