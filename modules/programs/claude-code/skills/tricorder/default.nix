{
  util,
  config,
  lib,
  inputs,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    gipphe.programs.claude-code.skills.tricorder =
      "${inputs.tricorder}/.claude-plugin/tricorder/skills/tricorder";
  };
}
