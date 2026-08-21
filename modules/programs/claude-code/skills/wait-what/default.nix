{
  util,
  config,
  lib,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    home.file.".claude/skills/wait-what/SKILL.md".source = ./SKILL.md;
  };
}
