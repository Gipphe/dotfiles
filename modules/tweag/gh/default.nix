{ util, lib, ... }:
util.mkToggledModule [ "tweag" ] {
  name = "gh";
  home-manager = {
    wrappers.gh.settings.aliases =
      let
        teamMembers = {
          "christian" = "cgeorgii";
        };
        teamMemberAliases = lib.mapAttrs' (name: username: {
          name = "add_${name}";
          value = "pr edit --add-reviewer ${username}";
        }) teamMembers;
      in
      teamMemberAliases;
  };
}
