{
  util,
  lib,
  config,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    home.file.".claude/skills/unslop/SKILL.md".source = ./SKILL.md;
  };
}
