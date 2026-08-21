{
  util,
  config,
  lib,
  inputs,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    home.file.".claude/skills/tricorder/SKILL.md".source =
      "${inputs.tricorder}/.claude-plugin/tricorder/skills/tricorder/SKILL.md";
  };
}
