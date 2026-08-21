{
  util,
  config,
  lib,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    home.file.".claude/skills/grilling/SKILL.md".source = ./SKILL.md;
  };
}
