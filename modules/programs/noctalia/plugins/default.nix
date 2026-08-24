{
  util,
  lib,
  config,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.noctalia.enable {
    programs.noctalia.settings.plugins.auto_update = "official";
  };
}
