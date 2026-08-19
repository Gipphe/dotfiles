{
  util,
  lib,
  config,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.noctalia.enable {
    # Handle updates declaratively.
    programs.noctalia.settings.plugins.auto_update = "none";
  };
}
