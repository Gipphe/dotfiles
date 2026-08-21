{
  util,
  config,
  lib,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    home.file.".claude/skills/writing-for-agents/SKILL.md".source = ./SKILL.md;
    home.file.".claude/skills/writing-for-agents/SKILL-MECHANICS.md".source = ./SKILL-MECHANICS.md;
  };
}
