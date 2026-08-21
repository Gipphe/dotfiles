{
  util,
  lib,
  config,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    home.file.".claude/skills/issue-tracker/SKILL.md".source = ./SKILL.md;
    gipphe.programs.git.ignores = /* gitignore */ ''
      .scratch/
    '';
  };
}
