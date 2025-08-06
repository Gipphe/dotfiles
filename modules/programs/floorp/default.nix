{
  util,
  config,
  lib,
  pkgs,
  flags,
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
    default = lib.mkEnableOption "Floorp as default browser" // {
      default = true;
    };
    package = lib.mkPackageOption pkgs "floorp" { } // {
      default = config.programs.floorp.finalPackage;
    };
  };
  hm.config = lib.mkMerge [
    {
      gipphe.default.browser = lib.mkIf cfg.default {
        name = "Floorp";
        inherit (cfg) package;
        actions.open = "${cfg.package}/bin/floorp";
      };
      programs.floorp = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        enable = cfg.enable || cfg.windows;
        package = pkg;
        profiles = {
          default = import ./profile.nix { inherit pkgs; };
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
    (lib.optionalAttrs (!flags.isNixOnDroid) {
      stylix.targets.floorp.profileNames = [ "default" ];
    })
  ];
  system-darwin = lib.mkIf cfg.enable { homebrew.casks = [ "floorp" ]; };
}
