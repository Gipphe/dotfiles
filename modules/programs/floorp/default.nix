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
in
util.mkModule {
  options.gipphe.programs.floorp = {
    enable = lib.mkEnableOption "floorp";
    default = lib.mkEnableOption "Floorp as default browser" // {
      default = true;
    };
  };
  shared.imports = [ ./windows.nix ];
  hm = {
    config = lib.mkMerge [
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
        }
      ))
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
  };
  system-darwin = lib.mkIf cfg.enable { homebrew.casks = [ "floorp" ]; };
}
