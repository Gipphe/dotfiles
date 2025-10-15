{ util, ... }:
util.mkToggledModule [ "tweag" ] {
  name = "vcs";
  hm = {
    programs = {
      git.includes = [
        {
          condition = "gitdir:~/projects/tweag";
          contents.user.email = "victor.bakke@tweag.io";
        }
        {
          condition = "gitdir:~/projects/modus-create";
          contents.user.email = "victor.bakke@tweag.io";
        }
      ];
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
