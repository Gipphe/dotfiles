{
  util,
  config,
  lib,
  ...
}:
let
  cfg = config.gipphe.programs.floorp;
  pkg = config.programs.floorp.finalPackage or config.programs.floorp.package;
in
util.mkModule {
  hm = {
    config = lib.mkIf cfg.default {
      home.sessionVariables = {
        BROWSER = lib.getExe' pkg "floorp";
        DEFAULT_BROWSER = lib.getExe' pkg "floorp";
      };
      gipphe.core.wm.binds = lib.mkIf cfg.default [
        {
          mod = "Mod";
          key = "B";
          action.spawn = lib.getExe' pkg "floorp";
        }
      ];
      xdg.mimeApps.defaultApplicationPackages = [ pkg ];
    };
  };
}
