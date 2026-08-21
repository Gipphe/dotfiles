{
  util,
  lib,
  config,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    home.file = {
      ".claude/skills/wizard/SKILL.md".source = ./SKILL.md;
      ".claude/skills/wizard/template.sh".source = ./template.sh;
    };
  };
}
