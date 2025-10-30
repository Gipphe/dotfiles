{ util, ... }:
# let
#   windows = {
#     backgroundTasksProfile = ''
#       [BackgroundTasksProfiles]
#       MozillaBackgroundTask-22EB8429C9C8096C-defaultagent=synsbn6s.MozillaBackgroundTask-22EB8429C9C8096C-defaultagent
#     '';
#   };
# in
util.mkToggledModule [ "programs" "floorp" ] {
  name = "windows";
  hm = {
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
      #       pkgs.runCommand "floorp-profiles" { } # bash
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
  };
}
