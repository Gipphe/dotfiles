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
  hmCfg = config.programs.floorp;
in
util.mkModule {
  options.gipphe.programs.floorp = {
    enable = lib.mkEnableOption "floorp";
    default = lib.mkEnableOption "Floorp as default browser" // {
      default = true;
    };
  };
  shared.imports = [
    ./windows.nix
    ./darwin.nix
  ];
  hm = lib.mkMerge [
    {
      programs.floorp = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && !flags.isNixOnDroid) {
        enable = true;
        profiles = {
          default = import ./profile.nix { inherit pkgs; };
        };
      };
    }
    (lib.optionalAttrs (!flags.isNixOnDroid) (
      lib.mkIf cfg.default {
        home.sessionVariables.BROWSER = "${
          config.programs.floorp.finalPackage or config.programs.floorp.package
        }/bin/floorp";
        gipphe.core.wm.binds = [
          {
            mod = "Mod";
            key = "B";
            action.spawn = "${hmCfg.package}/bin/floorp";
          }
        ];
      }
    ))
    (lib.optionalAttrs (!flags.isNixOnDroid) {
      stylix.targets.floorp.profileNames = [ "default" ];
    })
  ];
}
