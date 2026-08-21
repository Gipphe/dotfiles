{
  util,
  config,
  lib,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    gipphe.programs.claude-code.skills.wait-what = ./.;
  };
}
