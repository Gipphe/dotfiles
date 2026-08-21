{
  util,
  lib,
  config,
  ...
}:
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    gipphe.programs.claude-code.skills.issue-tracker = ./.;
    gipphe.programs.git.ignores = /* gitignore */ ''
      .scratch/
    '';
  };
}
