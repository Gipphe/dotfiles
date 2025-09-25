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
  pkg = config.programs.floorp.finalPackage or config.programs.floorp.package;
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
  hm.config = lib.mkMerge [
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
        home.sessionVariables.BROWSER = "${pkg}/bin/floorp";
        gipphe.core.wm.binds = lib.mkIf cfg.default [
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
