{
  util,
  config,
  lib,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    home.file = {
      ".claude/skills/show-me-your-work/SKILL.md".source = ./SKILL.md;
      ".claude/skills/show-me-your-work/scripts/log.sh".source = ./scripts/log.sh;
      ".claude/skills/show-me-your-work/references/decision-log-template.tsv".source =
        ./references/decision-log-template.tsv;
    };
  };
}
