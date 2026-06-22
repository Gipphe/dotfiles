{
  pkgs,
  util,
  lib,
  ...
}:
let
  tweagGit = pkgs.writeText "tweag-git-config" (
    lib.generators.toGitINI {
      user.email = "victor.bakke@tweag.io";
    }
  );
in
util.mkToggledModule [ "tweag" ] {
  name = "vcs";
  homeManager = {
    wrappers = {
      git.settings.includeIf = {
        "gitdir:~/projects/tweag".path = tweagGit.outPath;
        "gitdir:~/projects/modus-create".path = tweagGit.outPath;
      };
      jujutsu.settings."--scope" = [
        {
          "--when".repositories = [
            "~/projects/tweag"
            "~/projects/modus-create"
          ];
          user.email = "victor.bakke@tweag.io";
        }
      ];
    };
  };
}
