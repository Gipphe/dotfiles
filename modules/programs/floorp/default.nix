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
  ];
  hm.config = lib.mkMerge [
    {
      programs.floorp = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && !flags.isNixOnDroid && cfg.enable) {
        enable = true;
        profiles = {
          default = import ./profile.nix { inherit pkgs; };
        };
        nativeMessagingHosts = [
          pkgs.tridactyl-native
        ];
      };
    }
    (lib.optionalAttrs (!flags.isNixOnDroid) (
      lib.mkIf (cfg.enable && cfg.default) {
        home.sessionVariables = {
          BROWSER = lib.getExe' pkg "floorp";
          DEFAULT_BROWSER = lib.getExe' pkg "floorp";
        };
        gipphe.core.wm.binds = [
          {
            mod = "Mod";
            key = "B";
            action.spawn = lib.getExe' pkg "floorp";
          }
        ];
        xdg.mimeApps.defaultApplicationPackages = [ pkg ];
      }
    ))
    (lib.optionalAttrs (!flags.isNixOnDroid && flags.stylix) {
      stylix.targets.floorp.profileNames = [ "default" ];
    })
  ];
}
